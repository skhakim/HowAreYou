from app import db
from models.models import Psychiatrist, Patient


class FileRequest(db.Model):
    __tablename__ = 'file_requests'
    file_request_id = db.Column(db.Integer, primary_key=True)
    created_at = db.Column(db.DateTime, nullable=False)
    title = db.Column(db.String(128), nullable=False)
    description = db.Column(db.UnicodeText)
    is_verified = db.Column(db.Boolean, default=False)
    psychiatrist_id = db.Column(db.Integer, db.ForeignKey('psychiatrists.psychiatrist_id'), nullable=False)


class FileUpload(db.Model):
    __tablename__ = 'file_uploads'
    file_upload_id = db.Column(db.Integer, primary_key=True)
    file_request_id = db.Column(db.Integer, db.ForeignKey('file_requests.file_request_id'), nullable=False)
    file_path = db.Column(db.String(256), nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)
    uploader_id = db.Column(db.Integer, db.ForeignKey('patients.patient_id'), nullable=False)
    uploader_comment = db.Column(db.UnicodeText)  # comment from the patient
    notification_pending = db.Column(db.Boolean, default=True)
