"""Consultation requests between patients and psychiatrists."""
from datetime import datetime, timedelta

import jwt
from flask import request, jsonify
from sqlalchemy.orm import aliased

from backend import app, db
from backend.models.export import Award, ConsultationRequest, CounsellingSuggestion, Degree, Disease, Notification, Person, Psychiatrist, PsychiatristAward, PsychiatristDegree, PsychiatristDisease, TestResult
from backend.services.auth import psychiatrist_token_required, patient_token_required
from backend.services.calendar import create_event
from backend.services.pseudonyms import get_pseudonym

date_map = {'Monday:': 0, 'Tuesday:': 1, 'Wednesday:': 2, 'Thursday:': 3, 'Friday:': 4, 'Saturday:': 5, 'Sunday:': 6}


@app.route('/pd/<int:_id>', methods=['GET'])
def psychiatrist_details(_id):
    psychiatrist, person = db.session.query(Psychiatrist, Person).filter(
        Psychiatrist.psychiatrist_id == Person.person_id).filter(Psychiatrist.psychiatrist_id == _id).first()
    ret = {"id": _id, "name": person.name, "cell": person.cellphone, "email": person.email, "cert": psychiatrist.certificate_id}

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

    print(ret)
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

    person = Person.query.filter_by(person_id=patient_id).first()
    psychiatrist = Person.query.filter_by(person_id=data['psychiatrist_id']).first()


    # create event in calendar
    create_event(consultation_request.con_time, "An appointment for " + person.name + " with Dr. " + psychiatrist.name
                 , person.email, psychiatrist.email)

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
