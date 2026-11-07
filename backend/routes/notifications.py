"""In-app notifications."""
import jwt
from flask import request, jsonify

from backend import app, db
from backend.models.export import Notification
from backend.services.auth import token_required

@app.route('/view_notifications/', methods=['GET'])
@token_required
def get_notifications(_):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    person_id = data['patient_id'] if 'patient_id' in data else data['psychiatrist_id']
    notifications = db.session.query(Notification).filter_by(person_id=person_id).order_by(Notification.seen).all()
    number_unseen_notifications = len(db.session.query(Notification).filter_by(person_id=person_id, seen=False).all())
    ret = ({"notifications": [{"id": x.notification_id, "from": x.type, "text": x.desc, "seen": x.seen} for x in
                              notifications], "number" : number_unseen_notifications})
    # for x in notifications:
    #     x.seen = True
    # db.session.commit()
    print(ret)
    return jsonify(ret)


@app.route('/mark_notifications/', methods=['POST'])
@token_required
def mark_notifications(_):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    person_id = data['patient_id'] if 'patient_id' in data else data['psychiatrist_id']
    notifications = db.session.query(Notification).filter_by(person_id=person_id).order_by(Notification.seen).all()
    for x in notifications:
        x.seen = True
    db.session.commit()
    return jsonify({"response": "success"})


@app.route('/no_notifications/', methods=['GET'])
@token_required
def no_unseen_notifications(_):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    person_id = data['patient_id'] if 'patient_id' in data else data['psychiatrist_id']
    notifications = db.session.query(Notification).filter_by(person_id=person_id).filter(Notification.seen == False).all()
    return jsonify({"count": len(notifications)})
