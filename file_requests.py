from datetime import datetime

import jwt
import os
import subprocess
from flask import request, jsonify, send_file
from werkzeug.security import generate_password_hash
from werkzeug.utils import secure_filename

from app import app
from authentication_controller import psychiatrist_token_required, token_required, patient_token_required, \
    is_review_board_member
from models.export import *


@app.route('/cfr', methods=['POST'])
@psychiatrist_token_required
def create_file_request(_):
    token = request.headers['x-access-token']
    token_data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    data = request.get_json()
    file_request = FileRequest(
        created_at = datetime.now(),
        title = data['title'],
        description = data['desc'],
        psychiatrist_id = token_data['psychiatrist_id']
    )
    db.session.add(file_request)
    db.session.commit()
    return "File request created!"


@app.route('/vfr_id/<int:file_request_id>', methods=['GET'])
@token_required
def get_file_request(_, file_request_id):
    file_request = FileRequest.query.with_entities(FileRequest.file_request_id, FileRequest.title, FileRequest.description).filter_by(file_request_id=file_request_id, is_verified=True).first()
    if file_request is None:
        return "File request not found!", 404
    return jsonify(dict(file_request))

@app.route('/vfr_id_rev/<int:file_request_id>', methods=['GET'])
@is_review_board_member
def get_file_request_rev(_, file_request_id):
    file_request = FileRequest.query.with_entities(FileRequest.file_request_id, FileRequest.title, FileRequest.description).filter_by(file_request_id=file_request_id).first()
    if file_request is None:
        return "File request not found!", 404
    return jsonify(dict(file_request))


@app.route('/vfr')
@token_required
def view_file_request(_):
    file_requests = FileRequest.query.with_entities(FileRequest.file_request_id, FileRequest.title).filter_by(is_verified=True).all()
    return jsonify([dict(_) for _ in file_requests])


@app.route('/upload/<int:frID>', methods=['POST'])
@patient_token_required
def upload_a_file(_, frID):
    token = request.headers['x-access-token']
    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
    patient_id = data['patient_id']
    # print(request.headers)
    os.makedirs(os.path.join(app.config['UPLOAD_FOLDER'], str(frID)), exist_ok=True) # create folder if not exists
    rf = request.files
    for r in rf:
        fname = secure_filename(r)
        fname = os.path.join(app.config['UPLOAD_FOLDER'], str(frID), generate_password_hash(str(patient_id) + fname)[-15:] + "_" + fname)
        rf[r].save(fname)
        print(r, type(rf[r]))
    file_upload = FileUpload(
        uploader_id = patient_id, created_at = datetime.now(), file_request_id = frID, file_path = fname
    )
    db.session.add(file_upload)
    db.session.commit() # commit the file upload
    return "OK"


@app.route('/vfu/<int:frID>')
def download_files(frID):
    fr_dir = os.path.join(app.config['UPLOAD_FOLDER'], str(frID))
    print(fr_dir)
    subprocess.call("zip tmp.zip -r " + fr_dir, shell=True)
    return send_file("tmp.zip", as_attachment=True)


@is_review_board_member
@app.route('/app_fr/<int:frID>')
def approve_file_request(frID):
    fr = FileRequest.query.filter_by(file_request_id=frID).first()
    fr.is_verified = True
    db.session.commit()
    return jsonify({'response': 'success'})


# @is_review_board_member
@app.route('/del_fr/<int:frID>')
def delete_file_request(frID):
    fr = FileRequest.query.filter_by(file_request_id=frID).first()
    db.session.delete(fr)
    db.session.commit()
    return jsonify({'response': 'success'})


