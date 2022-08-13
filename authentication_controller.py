from datetime import timedelta, datetime
from functools import wraps
from werkzeug.security import generate_password_hash

import jwt
from flask import request, jsonify, make_response
from werkzeug.security import check_password_hash

from app import app, db
from models.models import Person, Patient, Psychiatrist, ReviewBoardMember


def generic_token_required(user_type, f):
    @wraps(f)
    def generic_decorator(*args, **kwargs):
        token = None
        # print(request.headers)
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
            print('Token in generic decorator', token)
        if not token:
            print('Token is missing', user_type)
            return jsonify({'message': 'Token is missing!'}), 401
        try:
            # print('PRINTING DATA')
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            print(data)
            if user_type == 'patient' or ('patient_id' in data.keys()):
                current_user = Patient.query.filter_by(patient_id=data['patient_id']).first()
            elif user_type == 'psychiatrist' or ('psychiatrist_id' in data.keys()):
                current_user = Psychiatrist.query.filter_by(psychiatrist_id=data['psychiatrist_id']).first()
                print(current_user)
            else:
                return jsonify({'message': 'Token is invalid!'}), 401
        except Exception as e:
            print(e)
            print('Token is invalid for', user_type)
            return jsonify({'message': 'Token is invalid!'}), 401
        print('Returning')
        return f(current_user, *args, **kwargs)
    return generic_decorator


token_required = lambda f : generic_token_required('person', f)
patient_token_required = lambda f : generic_token_required('patient', f)
psychiatrist_token_required = lambda f : generic_token_required('psychiatrist', f)
is_review_board_member = lambda f : is_review_board_member(f)


@app.route('/logout', methods=['GET', 'POST'])
@token_required
def generic_logout():
    jwt.encode(dict())


def is_review_board_member(f):
    @wraps(f)
    def generic_decorator(*args, **kwargs):
        token = None
        print('Here')
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
            print('Token in generic decorator', token)
        if not token:
            print('Token is missing')
            return jsonify({'message': 'Token is missing!'}), 401
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            current_user = ReviewBoardMember.query.filter_by(board_member_id=data['psychiatrist_id']).first()
            if current_user is None:
                return jsonify({'message': 'You are not an authorized Review Board Member!'}), 401
        except:
            print('Token is invalid for Review Board Member')
            return jsonify({'message': 'Token is invalid!'}), 401
        print('Returning')
        return f(current_user, *args, **kwargs)
    return generic_decorator



def generic_login(auth):
    global id_name
    if not auth or not auth.get('email') or not auth.get('password'):
        return make_response('Could not verify', 401, {'Authenticate': "Login required!"})
    user = Person.query.filter_by(email=auth.get('email')).first()
    if user.role == 'patient':
        id_name = 'patient_id'
    elif user.role == 'psychiatrist':
        id_name = 'psychiatrist_id'
    if user is not None and check_password_hash(user.password_hash, auth.get('password')):
        token = jwt.encode({id_name: user.person_id, 'exp': datetime.utcnow() + timedelta(minutes=600)},
                           app.config['SECRET_KEY'])
        return make_response(jsonify({'token': token}, {'id_name': id_name}, {'person_id': user.person_id}
                                        , {'name': user.name}), 201)
    return make_response('Could not verify', 403, {'Authenticate': "Login required!"})


def patient_signup_control(_id, _request):
    data = _request.get_json(force=True)
    name, email = data.get('name'), data.get('email_')
    password = data.get('password_')
    dob = data.get('dob')
    gender = data.get('gender')[0]
    user = Person.query.filter_by(email=email).first()

    if not user:
        if _id == 1:
            height_inches = data.get('height')
            weight_kgs = data.get('weight')
            location = data.get('location')
            patient = Patient(
                height_inches=height_inches, weight_kgs = weight_kgs, location = location, date_of_birth = dob,
                gender = gender, photo_path = 'https://picsum.photos/200',
                name=name, email=email, password_hash=generate_password_hash(password))
            db.session.add(patient)
        elif _id == 2:
            certificateId = data.get('certificateId')
            psychiatrist = Psychiatrist(
                certificate_id = certificateId, date_of_birth = dob, gender = gender, photo_path = 'https://picsum.photos/200'
                , name = name, email = email, password_hash = generate_password_hash(password))
            db.session.add(psychiatrist)
        db.session.commit()
        return make_response('Successfully registered.', 201)
    else:
        return make_response('User already exists. Please Log in.', 202)