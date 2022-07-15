from app import *
from authentication import *
from take_questionnaire import *
import flask_restless


@patient_token_required
def is_patient_logged_in(_ = None, **kwargs):
    return True


# Create the Flask-Restless API manager.
manager = flask_restless.APIManager(session=db.session)
person_blueprint = manager.create_api(Person, methods=['GET', 'POST'], exclude=['password_hash'])
test_blueprint = manager.create_api(Option, methods=['GET'])
manager.create_api(Test, methods=['GET', 'POST'])
manager.create_api(Question, methods=['GET', 'POST'])
manager.create_api(TestResult, methods=['GET', 'POST', 'PATCH'], collection_name='tr')

manager.init_app(app)

app.run(debug=True, host='0.0.0.0')
