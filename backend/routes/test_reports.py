"""Test responses and psychiatrist review reports."""
from datetime import datetime

import random

import jwt
from flask import request, jsonify
from sqlalchemy import desc

from backend import app, db
from backend.models.export import CounsellingSuggestion, Disease, Notification, Person, Psychiatrist, PsychiatristDisease, Test, TestResult, TestResultDisease
from backend.services.auth import psychiatrist_token_required, patient_token_required
from backend.services.test_reports import fetch_patient_responses, fetch_test_responses

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
            .filter(TestResult.patient_id == data['patient_id']).order_by(desc(TestResult.verified_at)).all()

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


@app.route('/show_patient_responses/<test_result_id>')
def show_patient_responses(test_result_id):
    return fetch_patient_responses(test_result_id)


@app.route('/responseBasic/<test_result_id>')
def rd(test_result_id):
    result = db.session.execute("""SELECT persons.name as patient_name, EXTRACT(YEAR FROM age(date_of_birth))::int as patient_age
    , persons.gender, p.height_inches, p.weight_kgs, p.location, tr.score, tests.name AS test_name
    FROM tests INNER JOIN test_results tr on tests.test_id = tr.test_id
        INNER JOIN persons ON persons.person_id = tr.patient_id
        INNER JOIN patients p on persons.person_id = p.patient_id WHERE tr.test_result_id = :test_result_id""", {'test_result_id': test_result_id})
    result = [dict(x) for x in result.mappings().all()]
    print(result[0])
    return jsonify({'responseBasic': result[0] })
