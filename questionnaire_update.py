from email.policy import default
from ssl import Options
from venv import create

import pseudonym_generator
from models.export import *
from flask import request
import jwt
from app import app, db
from check_test_reponses_controller import *
from authentication_controller import psychiatrist_token_required, patient_token_required, is_review_board_member
from datetime import datetime
import random


@app.route('/test/<test_id>/add_question', methods=['POST'])
@psychiatrist_token_required
def add_question(_, test_id):
    print(request.json)
    question = Question(question_text=request.json['text'], created_at=datetime.now(), is_approved=False)
    db.session.add(question)
    db.session.commit()
    db.session.refresh(question)
    print(question.question_id)
    for option in request.json['options']:
        opt = Option(option_text=option['text'], question_id=question.question_id, score=option['score'])
        db.session.add(opt)
    db.session.commit()
    stmt = TestQuestion.insert().values(test_id=test_id, question_id=question.question_id, is_approved=False)
    db.session.execute(stmt)
    db.session.commit()
    return jsonify({"response": 'success'})


@app.route('/get_ques/<ques_id>/<test_id>', methods=['GET'])
def get_ques(ques_id, test_id):
    test = Test.query.filter_by(test_id=test_id).first()
    question = Question.query.filter_by(question_id=ques_id).first()
    options = Option.query.filter_by(question_id=ques_id).all()
    return jsonify({"quesBody": question.question_text, "options": [opt.option_text for opt in options]
                       , "mode": "add", "requestBy": pseudonym_generator.get_pseudonym()
                       , "id": test_id, "testName": test.name})


@app.route('/test/<test_id>/get_all_questions', methods=['GET'])
@psychiatrist_token_required
def get_all_questions(_, test_id):
    questions = db.session.query(TestQuestion).filter_by(test_id=test_id).filter_by(is_approved=True).all()
    # 2nd Item is the question ID
    question_ids = [x[1] for x in questions]
    all_questions = []
    for question in question_ids:
        q_dict = {}
        result = db.session.query(Question).filter_by(question_id=question).first()
        q_dict["questionText"] = result.question_text
        q_dict["id"] = result.question_id
        q_dict["options"] = [{"id": x.option_id, "value": x.option_text} for x in result.options]
        all_questions.append(q_dict)
    test = db.session.query(Test).filter_by(test_id=test_id).first()
    return jsonify({"questions": all_questions, "name": test.name})


@app.route('/test/<test_id>/delete_question/<q_id>', methods=['POST'])
@psychiatrist_token_required
def delete_question(_, test_id, q_id):
    stmt = TestQuestion.update().where(TestQuestion.c.test_id == test_id) \
        .where(TestQuestion.c.question_id == q_id).values(pending_delete=True,
                                                          delete_reasoning=request.get_json()['reasoning'])
    db.session.execute(stmt)
    db.session.commit()
    return jsonify({"response": 'success'})


@app.route('/approve_question/<test_id>/<q_id>', methods=['POST'])
@is_review_board_member
def approve_question(_, test_id, q_id):
    print('Starting')
    stmt = TestQuestion.update().where(TestQuestion.c.question_id == q_id). \
        where(TestQuestion.c.test_id == test_id).values(is_approved=True)
    db.session.execute(stmt)
    print('Midway')
    q = Question.query.filter_by(question_id=q_id).first()
    q.is_approved = True
    db.session.add(q)
    db.session.commit()
    return jsonify({"response": 'success'})


@app.route('/reject_question/<test_id>/<q_id>', methods=['POST'])
@is_review_board_member
def reject_question(_, test_id, q_id):
    stmt = TestQuestion.delete().where(TestQuestion.c.question_id == q_id) \
        .where(TestQuestion.c.is_approved == False).where(TestQuestion.c.test_id == test_id)
    db.session.execute(stmt)
    db.session.commit()
    if db.session.query(TestQuestion).filter_by(question_id=q_id).first() is None:
        db.session.query(Option).filter(Option.question_id == q_id).delete()
        db.session.commit()
        q = Question.query.filter_by(question_id=q_id).delete()
        db.session.commit()
        return jsonify({"response": 'success'})
    else:
        return jsonify({"response": 'Question has no pending approval'})


@app.route('/approve_delete_question/<test_id>/<q_id>', methods=['POST'])
@is_review_board_member
def approve_delete_question(_, test_id, q_id):
    stmt = TestQuestion.delete().where(TestQuestion.c.question_id == q_id) \
        .where(TestQuestion.c.pending_delete == True).where(TestQuestion.c.test_id == test_id)
    out = db.session.execute(stmt)
    db.session.commit()
    if db.session.query(TestQuestion).filter_by(question_id=q_id).first() is None:
        Option.query.filter_by(question_id=q_id).delete()
        db.session.commit()
        q = Question.query.filter_by(question_id=q_id).delete()
        db.session.commit()
        return jsonify({"response": 'success'})
    else:
        return jsonify({"response": 'Question still has no pending delete'})


@app.route('/reject_delete_question/<test_id>/<q_id>', methods=['POST'])
@is_review_board_member
def reject_delete_question(_, test_id, q_id):
    stmt = TestQuestion.update().where(TestQuestion.c.question_id == q_id) \
        .where(TestQuestion.c.pending_delete == True).where(TestQuestion.c.test_id == test_id) \
        .values(pending_delete=False)
    db.session.execute(stmt)
    db.session.commit()
    return jsonify({"response": 'success'})


@app.route('/quesReviewRequests', methods=['GET'])
@is_review_board_member
def get_ques_review_requests(_):
    questions = db.session.execute('SELECT t.test_id, question_id, t.name '
                                   'FROM test_question INNER JOIN tests t on t.test_id = test_question.test_id '
                                   'WHERE test_question.is_approved = false')
    del_questions = db.session.execute('SELECT t.test_id, question_id, t.name, delete_reasoning '
                                        'FROM test_question INNER JOIN tests t on t.test_id = test_question.test_id '
                                        'WHERE test_question.pending_delete = true')
    # file_requests = db.session.query(FileRequest).filter_by(is_verified=False).all()
    # print(file_requests[0])
    res = ({"questions":
                    # [{"id": x.file_request_id, "testName": x.title, "mode": "file request"} for x in file_requests]
                        [{"id": x[1], "testId": x[0], "testName": x[2], "mode": "add"} for x in questions]
                        + [{"id": x[1], "testId": x[0], "testName": x[2], "mode": "delete", "reasoning": x[3]} for
                           x in del_questions]})
    print(res)
    return jsonify(res)
