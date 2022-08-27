# from unittest import TestResult
from email.policy import default

from sqlalchemy import desc
from sqlalchemy.orm import aliased
from models.export import *
from flask import request
import jwt
from app import app, db
from check_test_reponses_controller import *
from authentication_controller import psychiatrist_token_required, patient_token_required, token_required
from datetime import datetime, timedelta
import random
from pseudonym_generator import get_pseudonym

date_map = {'Monday:': 0, 'Tuesday:': 1, 'Wednesday:': 2, 'Thursday:': 3, 'Friday:': 4, 'Saturday:': 5, 'Sunday:': 6}


@app.route('/pd/<int:_id>', methods=['GET'])
def psychiatrist_details(_id):
    psychiatrist, person = db.session.query(Psychiatrist, Person).filter(
        Psychiatrist.psychiatrist_id == Person.person_id).filter(Psychiatrist.psychiatrist_id == _id).first()
    ret = {"id": _id, "name": person.name, "cell": person.cellphone, "email": person.email}

    dis = db.session.query(PsychiatristDisease, Disease).filter(PsychiatristDisease.psychiatrist_id == _id) \
        .filter(PsychiatristDisease.disease_id == Disease.disease_id).all()
    print(dis)
    ret["area_of_expertise"] = [x[1].name for x in dis]

    awards = db.session.query(PsychiatristAward, Award).filter(PsychiatristAward.psychiatrist_id == _id) \
        .filter(PsychiatristAward.award_id == Award.award_id).all()
    ret["awards"] = [x[1].name + " - " + x[1].host for x in awards]

    degrees = db.session.query(PsychiatristDegree, Degree).filter(PsychiatristDegree.psychiatrist_id == _id) \
        .filter(PsychiatristDegree.degree_id == Degree.degree_id).all()
    ret["designation"] = "; ".join([x[1].name + '[' + x[1].institution + ']' for x in degrees])

    ret["available_hours"] = psychiatrist.available_times.split(";")

    return jsonify(ret)  # psychiatrist.to_json()


def next_day(weekday, given_date=datetime.now()):
    day_shift = (weekday - given_date.weekday()) % 7
    return given_date + timedelta(days=day_shift)


@app.route('/make_consul_request', methods=['POST'])
@patient_token_required
def make_consul_request(_):
    data = request.get_json(force=True)
    # print(data)
    _ = data['schedule'].split(" ")
    date = date_map[_[0]]
    print(int(_[1]) + 0 if (_[2] == 'AM') else 12)
    con_time = next_day(date).replace(hour=int(_[1]) + (0 if (_[2] == 'AM') else 12), minute=0, second=0,
                                        microsecond=0)
    consultation_request = ConsultationRequest(
        counsel_id=data['counsel_id'],
        test_result_id=data['test_result_id'],
        schedule=data['schedule'],
        con_time=con_time,
    )
    db.session.add(consultation_request)
    db.session.commit()

    pq = db.session.query(CounsellingSuggestion).filter(CounsellingSuggestion.c.counsel_id == data['counsel_id'])
    pq = db.session.execute(pq).first()
    psychiatrist_id = pq[2]
    print(psychiatrist_id)
    notification = Notification(type='C', person_id=psychiatrist_id,
                                desc='A patient has asked for a consultation at ' + data['schedule'])

    db.session.add(notification)
    db.session.commit()
    return "OK"


@app.route('/test_responses')
@psychiatrist_token_required
def test_responses(_):
    # print('gewgaw00')
    return jsonify({'results': fetch_test_responses()})


@app.route('/submit_review_report/<int:test_response_id>', methods=['POST'])
@psychiatrist_token_required
def submit_response(_, test_response_id):
    # print(request.json)
    # #insert comment into test result table
    # Psy Suggestions to be placed here
    psy_suggestions = []

    # Update Comment , Verified Date, Verified By
    test_result = TestResult.query.filter_by(test_result_id=test_response_id).first()
    test_result.manual_report = request.json['comment']
    test_result.verifier_id = request.json['verifier_id']
    test_result.verified_at = datetime.now()

    # Add Suggested Diagnosis & Find corresponding Expert
    for disease in request.json["disorder"]:
        if request.json["disorder"][disease]:
            disease_id = Disease.query.filter_by(name=disease).first().disease_id
            stmt = TestResultDisease.insert().values(test_result_id=test_response_id, disease_id=disease_id)
            db.session.execute(stmt)
            psy_suggestions += [(x[1].person_id, x[1].name) for x in db.session.query(PsychiatristDisease, Person) \
                .join(Person, Person.person_id == PsychiatristDisease.psychiatrist_id) \
                .filter(PsychiatristDisease.disease_id == disease_id).all()]

    # Randomly Choose 3 Psychiatrists; if there are less than 3, then use all of them
    if len(psy_suggestions) > 3:
        psy_suggestions = random.sample(psy_suggestions, 3)

    # Add Suggested Psychiatrists to Counselling Suggestion Table
    for idx, _ in psy_suggestions:
        stmt = CounsellingSuggestion.insert().values(test_result_id=test_response_id, psychiatrist_id=idx)
        db.session.execute(stmt)

    print(test_response_id)

    verifier = Psychiatrist.query.filter_by(psychiatrist_id=test_result.verifier_id).first()
    test = Test.query.filter_by(test_id=test_result.test_id).first()
    _not = Notification(type='V', desc='Dr. ' + verifier.name + ' has verified your report for ' + test.name, person_id=test_result.patient_id)
    db.session.add(_not)

    db.session.commit()

    return jsonify({"response": 'success'})


# @patient_token_required
# def view_verified_report(_,patient):
#     

@app.route('/view_verified_report', methods=['GET'])
@app.route('/view_verified_report/<int:test_response_id>', methods=['GET'])
@patient_token_required
def view_verified_report(_, test_response_id=None):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    # Base URL
    if test_response_id is None:
        # Filter the Verified Results
        test_result = db.session.query(TestResult, Test, Person).join(Test, TestResult.test_id == Test.test_id) \
            .join(Person, Person.person_id == TestResult.verifier_id) \
            .filter(TestResult.patient_id == data['patient_id']).all()

        # Get Psychiatrist Suggestions
        psy_suggestions = db.session.query(CounsellingSuggestion, Person) \
            .join(Person, CounsellingSuggestion.c.psychiatrist_id == Person.person_id).all()

        sugg = dict()
        # Get Test Results
        for x in psy_suggestions:
            if (dict(x))['test_result_id'] not in sugg:
                sugg[(dict(x))['test_result_id']] = []
            # sugg[(dict(x))['test_result_id']] += [x[-1].name]
            sugg[(dict(x))['test_result_id']] += [{"psychiatrist_id": x[-1].person_id
                                                      , "name": x[-1].name, "counsel_id": dict(x)['counsel_id']}]
        print(sugg)

        # Last item is the Person Object
        # psy_suggestions = [{"psychiatrist_id" : x[-1].person_id, "name" : x[-1].name } for x in psy_suggestions]

        # index 0 is TestResult , 1 is Test, and so on
        return jsonify({"verified_reports": [{"reportId": x[0].test_result_id, "test_name": x[1].name,
                                              "submitted_at": x[0].submitted_at, "verified_at": x[0].verified_at
                                                 , "psychiatrist": x[2].name,
                                              "manual_report": x[0].manual_report, "systemScore": x[0].score,
                                              "suggestedPsychiatrists": sugg.get(x[0].test_result_id, [])} for x in
                                             test_result]})
    else:
        test_result = TestResult.query.filter_by(test_result_id=test_response_id).first()
        try:
            if test_result.patient_id == data['patient_id']:
                return fetch_patient_responses(test_response_id)
            else:
                return jsonify({"error": "You are not authorized to view this report"})
        except:
            return jsonify({"error": "ERRRORRRRRR You are not authorized to view this report"})


@app.route('/send_consultation_request/', methods=['POST'])
@patient_token_required
def send_consultation_request(_):
    # insert consultation request in table
    consultation_request = ConsultationRequest(counsel_id=request.json['counsel_id'],
                                               test_result_id=request.json['test_result_id'],
                                               info=request.json['info'], schedule=request.json['schedule'],
                                               method=request.json['method'],
                                               fee=request.json['fee'])
    db.session.add(consultation_request)
    db.session.commit()
    return jsonify({"response": 'success'})


@app.route('/view_consultation_request/', methods=['GET'])
@psychiatrist_token_required
def view_consultation_request(_):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    # get all consultation requests for this psychiatrist
    consultation_requests = db.session.query(ConsultationRequest, CounsellingSuggestion) \
        .join(CounsellingSuggestion, CounsellingSuggestion.c.counsel_id == ConsultationRequest.counsel_id) \
        .filter(CounsellingSuggestion.c.psychiatrist_id == data['psychiatrist_id']).all()

    return jsonify({"consultation_requests": [{"id": x[0].consultation_request_id,
                                               "time": x[0].schedule, "method": x[0].method, "fee": x[0].fee,
                                               "approved": x[0].approved,
                                               "info": x[0].info, "name": get_pseudonym()} for x in
                                              consultation_requests]})


@app.route('/view_appointments/<string:st>', methods=['GET'])
@psychiatrist_token_required
def view_appointments(_, st=''):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    # get all approved consultation requests for this psychiatrist
    print("ST:", st)
    consultation_requests = db.session.query(ConsultationRequest, CounsellingSuggestion) \
        .join(CounsellingSuggestion, CounsellingSuggestion.c.counsel_id == ConsultationRequest.counsel_id) \
        .filter(CounsellingSuggestion.c.psychiatrist_id == data['psychiatrist_id']) \
        .filter(ConsultationRequest.approved != (st == 'pending')).all()


    return jsonify({"consultation_requests": [{"id": x[0].consultation_request_id,
                                               "sched": x[0].schedule, "time": str(x[0].con_time), "mode": x[0].method,
                                               "fee": x[0].fee,

                                               "info": x[0].info, "name": get_pseudonym()} for x in
                                              consultation_requests]})


@app.route('/accept_consultation_request/<int:consultation_id>', methods=['POST'])
@psychiatrist_token_required
def accept_consultation_request(_, consultation_id):
    # update consultation request
    consultation_request = ConsultationRequest.query.filter_by(consultation_request_id=consultation_id).first()
    consultation_request.approved = True
    db.session.commit()

    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    name = Psychiatrist.query.filter_by(person_id=data['psychiatrist_id']).first().name # get name of psychiatrist
    patient_id = TestResult.query.filter_by(test_result_id=consultation_request.test_result_id).first().patient_id # get patient id
    # send notification to patient
    notification = Notification(person_id=patient_id,
                                type='A',
                                desc=f'Dr. {name} has accepted your consultation request at '
                                                     f'{str(consultation_request.con_time)}')
    db.session.add(notification)
    db.session.commit()

    return jsonify({"response": 'success'})


@app.route('/delete_consultation_request/<int:consultation_id>', methods=['POST'])
@psychiatrist_token_required
def delete_consultation_request(_, consultation_id):
    # update consultation request
    consultation_request = ConsultationRequest.query.filter_by(consultation_request_id=consultation_id).first()

    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    name = Psychiatrist.query.filter_by(person_id=data['psychiatrist_id']).first().name
    patient_id = TestResult.query.filter_by(test_result_id=consultation_request.test_result_id).first().patient_id # get patient id
    notification = Notification(person_id=patient_id,
                                type='D',
                                desc=f'Dr. {name} has declined your consultation request at '
                                     f'{str(consultation_request.con_time)}')
    db.session.add(notification)
    db.session.delete(consultation_request)
    db.session.commit()
    return jsonify({"response": 'success'})


@app.route('/view_accepted_consultation_request/', methods=['GET'])
@patient_token_required
def view_accepted_consultation_request(_):
    # get all consultation requests for this patient
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    consultation_requests = db.session.query(ConsultationRequest, TestResult, Person) \
        .join(TestResult, ConsultationRequest.test_result_id == TestResult.test_result_id) \
        .join(Person, Person.person_id == TestResult.patient_id) \
        .filter(Person.person_id == data['patient_id']).all()

    return jsonify({"consultation_requests": [{"requestId": x[0].consultation_request_id,
                                               "schedule": x[0].schedule, "method": x[0].method, "fee": x[0].fee,
                                               "info": x[0].info} for x in consultation_requests]})


@app.route('/consultation_requests')
@patient_token_required
def get_consultation_requests(_):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    PersonP = aliased(Person)
    consultation_requests = db.session.query(ConsultationRequest, TestResult, Person, PersonP) \
        .join(TestResult, ConsultationRequest.test_result_id == TestResult.test_result_id) \
        .join(Person, Person.person_id == TestResult.patient_id) \
        .join(PersonP, PersonP.person_id == TestResult.verifier_id) \
        .filter(Person.person_id == data['patient_id']).filter(ConsultationRequest.approved).all()

    return jsonify({"consultation_requests": [{"id": x[0].consultation_request_id,
                                               "time": x[0].schedule, "text": "Doctor " + x[
            -1].name + " has accepted your consultation request."} for x in consultation_requests]})


@app.route('/view_notifications/', methods=['GET'])
@token_required
def get_notifications(_):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    person_id = data['patient_id'] if 'patient_id' in data else data['psychiatrist_id']
    notifications = db.session.query(Notification).filter_by(person_id=person_id).order_by(Notification.seen).all()
    number_unseen_notifications = len(db.session.query(Notification).filter_by(person_id=person_id, seen=False).all())
    ret = ({"notifications": [{"id": x.notification_id, "from": x.type, "text": x.desc, "seen": x.seen} for x in
                              notifications], "number" : number_unseen_notifications})
    # for x in notifications:
    #     x.seen = True
    # db.session.commit()
    print(ret)
    return jsonify(ret)


@app.route('/mark_notifications/', methods=['POST'])
@token_required
def mark_notifications(_):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    person_id = data['patient_id'] if 'patient_id' in data else data['psychiatrist_id']
    notifications = db.session.query(Notification).filter_by(person_id=person_id).order_by(Notification.seen).all()
    for x in notifications:
        x.seen = True
    db.session.commit()
    return jsonify({"response": "success"})


@app.route('/no_notifications/', methods=['GET'])
@token_required
def no_unseen_notifications(_):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    person_id = data['patient_id'] if 'patient_id' in data else data['psychiatrist_id']
    notifications = db.session.query(Notification).filter_by(person_id=person_id).filter(Notification.seen == False).all()
    return jsonify({"count": len(notifications)})

