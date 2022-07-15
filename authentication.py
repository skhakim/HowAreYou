from app import app
from models import *
from qa_models import *
from werkzeug.security import generate_password_hash, check_password_hash
from flask import jsonify, make_response, request
from functools import wraps
import jwt
from datetime import datetime, timedelta
import uuid


app.config['SECRET_KEY'] = 'HahaNoSecret'


def generic_token_required(user_type, f):
    @wraps(f)
    def generic_decorator(*args, **kwargs):
        token = None
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
        if not token:
            return jsonify({'message': 'Token is missing!'}), 401
        try:
            # print('PRINTING DATA')
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            # print('PRINTING DATA 2')
            print(data)
            if user_type == 'Person':
                current_user = Person.query.filter_by(person_id=data['person_id']).first()
            elif user_type == 'Patient':
                current_user = Patient.query.filter_by(patient_id=data['patient_id']).first()
            elif user_type == 'Psychiatrist':
                # print('PRINTING DATA 3')
                current_user = Psychiatrist.query.filter_by(psychiatrist_id=data['psychiatrist_id']).first()
                # print(current_user)
        except:
            return jsonify({'message': 'Token is invalid!'})
        return f(current_user, *args, **kwargs)
    return generic_decorator


token_required = lambda f : generic_token_required('Person', f)
patient_token_required = lambda f : generic_token_required('Patient', f)
psychiatrist_token_required = lambda f : generic_token_required('Psychiatrist', f)


@app.route('/logout', methods=['GET', 'POST'])
@token_required
def generic_logout():
    jwt.encode(dict())


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


def generic_login(user_type, auth):
    if not auth or not auth.get('email') or not auth.get('password'):
        return make_response('Could not verify', 401, {'Authenticate': "Login required!"})
    user = Person.query.filter_by(email=auth.get('email')).first()
    print(user)
    if user_type == 'Person':
        id_name = 'person_id'
    elif user_type == 'Patient':
        id_name = 'patient_id'
    elif user_type == 'Psychiatrist':
        id_name = 'psychiatrist_id'
    if user is not None and check_password_hash(user.password_hash, auth.get('password')):
        token = jwt.encode({id_name: user.person_id, 'exp': datetime.utcnow() + timedelta(minutes=60)},
                           app.config['SECRET_KEY'])
        return make_response(jsonify({'token': token}), 201)
    return make_response('Could not verify', 403, {'Authenticate': "Login required!"})


@app.route('/login', methods=['POST'])
def login():
    auth = request.get_json()
    print(auth)
    return generic_login('Person', auth)


@app.route('/patient_login', methods=['POST'])
def patient_login():
    auth = request.form
    return generic_login('Patient', auth)


@app.route('/psychiatrist_login', methods=['POST'])
def psychiatrist_login():
    auth = request.form
    return generic_login('Psychiatrist', auth)


@app.route('/signup', methods=['POST'])
def signup():
    data = request.form
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


@app.route('/patient_signup', methods=['POST'])
def patient_signup():
    data = request.form
    name, email = data.get('name'), data.get('email')
    password = data.get('password')
    height_inches = data.get('height_inches')

    user = Person.query.filter_by(email=email).first()

    if not user:
        # user = Person(
        #     name=name,
        #     email=email,
        #     password_hash=generate_password_hash(password))
        # db.session.add(user)
        # db.session.commit()
        # user = Person.query.filter_by(email=email).first()
        patient = Patient(
            height_inches=height_inches, name=name, email=email, password_hash=generate_password_hash(password))
        db.session.add(patient)
        db.session.commit()
        return make_response('Successfully registered.', 201)
    else:
        return make_response('User already exists. Please Log in.', 202)