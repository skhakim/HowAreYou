"""REST API for the models, generated with Flask-Restless-NG."""
import flask_restless

from backend import app, db
from backend.models.export import Disease, FileRequest, Option, Person, Psychiatrist, Question, Test, TestResult
from backend.services.auth import patient_token_required


def is_patient_logged_in(_=None, **kwargs):
    """Flask-Restless preprocessor: reject requests without a patient token."""

    @patient_token_required
    def internal():
        print('It came inside internal')
        return True

    print('Outside internal')
    try:
        if internal()[1] == 401:
            print('Internal completed without error. Should raise exception.')
            ex = True
    except Exception:
        print('In except')
        ex = False
    if ex:
        raise flask_restless.ProcessingException(detail='Not signed up as patient', status=401)


manager = flask_restless.APIManager(session=db.session)

_patient_only = {
    'GET_COLLECTION': [is_patient_logged_in],
    'GET_RESOURCE': [is_patient_logged_in],
    'POST_RESOURCE': [is_patient_logged_in],
}

person_blueprint = manager.create_api(Person, methods=['GET', 'POST'], exclude=['password_hash'])
manager.create_api(Option, methods=['GET'], preprocessors=_patient_only)
manager.create_api(Test, methods=['GET', 'POST'])
manager.create_api(Question, methods=['GET', 'POST'])
manager.create_api(TestResult, methods=['GET', 'POST', 'PATCH'], collection_name='tr', preprocessors=_patient_only)
manager.create_api(Disease, methods=['GET'])
manager.create_api(FileRequest, methods=['GET'], collection_name='fr')
manager.create_api(Psychiatrist, methods=['GET'])

manager.init_app(app)
