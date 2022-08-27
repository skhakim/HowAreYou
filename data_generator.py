from models.export import *
from app import app, db
from multidict import MultiDict
import numpy as np
from datetime import datetime
from random import randrange
from datetime import timedelta
import sys
def random_date(start, end):
    """
    This function will return a random datetime between two datetime 
    objects.
    """
    delta = end - start
    int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
    random_second = randrange(int_delta)
    return start + timedelta(seconds=random_second)

d1 = datetime.strptime('8/1/2022 1:30 PM', '%m/%d/%Y %I:%M %p')
d2 = datetime.strptime('8/25/2022 4:50 AM', '%m/%d/%Y %I:%M %p')


#Generate Test Results
results = db.session.query(TestQuestion, Option).filter(TestQuestion.c.question_id == Option.question_id)\
                                                    .filter(TestQuestion.c.is_approved==True).all()

q_multidict = MultiDict()
option_multidict = MultiDict()
for result in results:
    q_multidict.add(str(result[0]), result[1])
    option_multidict.add(str(result[1]), result[-1].option_id)

#Get All Patients ID
patients = [x.patient_id for x in db.session.query(Patient).all()]
psychiatrists = [x.psychiatrist_id for x in db.session.query(Psychiatrist).all()]
diseases = [x.disease_id for x in db.session.query(Disease).all()]
#Choose a Random Test
tests = [1,2,3]
print(f'Generating {sys.argv[1]} Fake Verified Test Results')
for nrows in range(int(sys.argv[1])):
    test_id = np.random.choice(tests)
    q_ids = sorted(set(q_multidict.getall(str(test_id))))
    new_test_result = TestResult(test_id = int(test_id),patient_id = int(np.random.choice(patients)),
                                 submitted_at = random_date(d1, d2), verifier_id = int(np.random.choice(psychiatrists)),
                                 verified_at = random_date(d1, d2) + timedelta(seconds=3600))
    db.session.add(new_test_result)
    db.session.commit()

    #Submit Responses
    for q_id in q_ids:
        option_ids = sorted(set(option_multidict.getall(str(q_id))))
        option_id = int(np.random.choice(option_ids))
        db.session.execute(Answer.insert().values(test_result_id = new_test_result.test_result_id, option_id = option_id))
        # db.session.commit()

    #Add Diseases
    ds = np.random.choice(diseases,2,replace=False)
    stmt = TestResultDisease.insert().values(test_result_id=new_test_result.test_result_id, disease_id=int(ds[0]))
    db.session.execute(stmt)
    stmt = TestResultDisease.insert().values(test_result_id=new_test_result.test_result_id, disease_id=int(ds[1]))
    db.session.execute(stmt)

print('Success')