import json

from authentication import *
from authentication_controller import patient_token_required
from take_questionnaire import *
from questionnaire_update import *
import flask_restless
from multidict import MultiDict
from check_test_reponses_controller import *
from file_requests import *
from check_test_reponses import *

from models.export import *
from trends import *
from models.disease_models import *


def is_patient_logged_in(_ = None, **kwargs):

    @patient_token_required
    def internal():
        print('It came inside internal')
        return True

    print('Outside internal')
    try:
        if internal()[1] == 401:
            print('Internal completed without error. Should raise exception.')
            ex = True
    except:
        print('In except')
        ex = False
    if ex:
        raise flask_restless.ProcessingException(detail='Not signed up as patient', status=401)


# Create the Flask-Restless API manager.
manager = flask_restless.APIManager(session=db.session) #, preprocessors={'GET_COLLECTION':[is_patient_logged_in], 'GET_RESOURCE':[is_patient_logged_in], 'POST_RESOURCE':[is_patient_logged_in]})

person_blueprint = manager.create_api(Person, methods=['GET', 'POST'], exclude=['password_hash'])
manager.create_api(Option, methods=['GET'], preprocessors={'GET_COLLECTION':[is_patient_logged_in], 'GET_RESOURCE':[is_patient_logged_in], 'POST_RESOURCE':[is_patient_logged_in]})
manager.create_api(Test, methods=['GET', 'POST']) #, preprocessors={'GET_COLLECTION':[is_patient_logged_in], 'GET_RESOURCE':[is_patient_logged_in], 'POST_RESOURCE':[is_patient_logged_in]})
manager.create_api(Question, methods=['GET', 'POST']) # , preprocessors={'GET_COLLECTION':[is_patient_logged_in], 'GET_RESOURCE':[is_patient_logged_in], 'POST_RESOURCE':[is_patient_logged_in]})
manager.create_api(TestResult, methods=['GET', 'POST', 'PATCH'], collection_name='tr', preprocessors={'GET_COLLECTION':[is_patient_logged_in], 'GET_RESOURCE':[is_patient_logged_in], 'POST_RESOURCE':[is_patient_logged_in]})

manager.create_api(Disease, methods=['GET'])
manager.create_api(FileRequest, methods=['GET'], collection_name='fr')
manager.create_api(Psychiatrist, methods=['GET'])

manager.init_app(app)

db.create_all()
app.run(debug=True, host='0.0.0.0')