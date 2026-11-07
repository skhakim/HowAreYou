"""Queries behind the test-response and review-report screens."""
from backend import db
from backend.services import pseudonyms
from flask import jsonify

from multidict import MultiDict


def fetch_test_responses():
    result = db.session.execute("""SELECT tests.name AS test_name, persons.name AS patient_name, tr.score, tr.test_result_id 
    FROM tests INNER JOIN test_results tr on tests.test_id = tr.test_id
        INNER JOIN persons ON persons.person_id = tr.patient_id
        WHERE tr.verifier_id IS NULL""")
    result = [dict(x) for x in result.mappings().all()]
    for res in result:
        res['patient_name'] = pseudonyms.get_pseudonym()
    return result


def fetch_test_result():
    pass


def fetch_patient_responses(test_result_id):
    result = db.session.execute("""SELECT q.question_id as q_id, question_text as q_text, o.option_id as o_id,  
        o2.option_text as choice, o.option_text as answer
        FROM tests INNER JOIN test_results tr on tests.test_id = tr.test_id
        INNER JOIN answer a on tr.test_result_id = a.test_result_id
        INNER JOIN options o on a.option_id = o.option_id
        INNER JOIN questions q on o.question_id = q.question_id
        INNER JOIN options o2 on q.question_id = o2.question_id
        WHERE a.test_result_id = :p_id""", {'p_id': test_result_id})

    q_text_dict = dict()
    q_choice_multidict = MultiDict()
    q_answer_dict = dict()

    result = [dict(x) for x in result.mappings().all()]
    processed_results =[]
    for row in result:
        q_text_dict[str(row['q_id'])] = row['q_text']
        q_answer_dict[str(row['q_id'])] = row['answer']
        q_choice_multidict.add(str(row['q_id']), row['choice'])
    # print(q_text_dict)
    # print(q_choice_multidict)
    for q_id in set(q_choice_multidict.keys()):
        processed_results += [{
            "question_text" : q_text_dict[q_id],
            "options" : [{"value" : x, "checked" : (x == q_answer_dict[q_id])} for x in list(q_choice_multidict.getall(q_id))] }]
    print(processed_results)
    return jsonify({'responseQuestions' : processed_results})

