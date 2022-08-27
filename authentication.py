from authentication_controller import *
from models.qa_models import *
from werkzeug.security import generate_password_hash
from flask import jsonify, make_response, request
import jwt

app.config['SECRET_KEY'] = 'HahaNoSecret'


@app.route('/user', methods=['GET'])
@token_required
def get_all_users(_):
    users = Person.query.all()
    output = []
    for user in users:
        output.append({
            'person_id': user.person_id,
            'name': user.name,
            'email': user.email
        })
    return jsonify({'users': output})


@app.route('/own', methods=['GET'])
@patient_token_required
def get_current_user(_):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    user = Patient.query.filter_by(patient_id=data['patient_id']).first()
    return {
            'public_id': user.person_id,
            'name': user.name,
            'email': user.email
        }


@app.route('/login', methods=['POST'])
def login():
    auth = request.get_json(force=True)
    return generic_login( auth)

#
# @app.route('/patient_login', methods=['POST'])
# def patient_login():
#     auth = request.get_json(force=True)
#     # print(auth)
#     return generic_login('Patient', auth)
#
#
# @app.route('/psychiatrist_login', methods=['POST'])
# def psychiatrist_login():
#     auth = request.get_json(force=True)
#     # print(auth)
#     return generic_login('Psychiatrist', auth)


@app.route('/signup', methods=['POST'])
def signup():
    data = request.get_json(force=True)
    name, email = data.get('name'), data.get('email')
    password = data.get('password')

    user = Person.query.filter_by(email=email).first()
    if not user:
        user = Person(
            name=name,
            email=email,
            password_hash=generate_password_hash(password))
        db.session.add(user)
        db.session.commit()
        return make_response('Successfully registered.', 201)
    else:
        return make_response('User already exists. Please Log in.', 202)


@app.route('/r')
@psychiatrist_token_required
def d(_):
    return 'Hello'


@app.route('/signup/<int:_id>', methods=['POST'])
def patient_signup(_id):
    return signup_control(_id, request)


@app.route('/info', methods=['POST'])
def print_info():
    print(request.get_json(force=True))
    """
    {'personType': 'patient', 'name': 'sbgnftr', 'email_': 'a@g.d', 'password_': 'vfetbtbrb', 'dob': '12-12-1202', 'gender': 'others', 'height': '85', 'weight': '120', 'location': 'sddcf', 'certificateId': ''}

    """
    return 'Hello, world!'


@app.route('/psy_not_app', methods=['GET'])
@is_review_board_member
def verify_psychiatrists(_):
    psychs = Psychiatrist.query.with_entities(Psychiatrist.psychiatrist_id, Psychiatrist.name, Psychiatrist.certificate_id)\
        .filter_by(is_verified=False).all()
    return jsonify({'psychiatrists': [dict(zip(['psychiatrist_id', 'name', 'certificate_id'], psych)) for psych in psychs]})

