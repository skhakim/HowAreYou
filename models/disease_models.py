from app import db
from models.models import Psychiatrist


class Disease(db.Model):
    __tablename__ = 'diseases'
    disease_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), nullable=False)
    description = db.Column(db.String(256))


class PsychiatristDisease(db.Model):
    __tablename__ = 'psychiatrist_disease'
    psychiatrist_id = db.Column('psychiatrist_id', db.Integer, db.ForeignKey('psychiatrists.psychiatrist_id'), primary_key=True)
    disease_id = db.Column('disease_id', db.Integer, db.ForeignKey('diseases.disease_id'), primary_key=True)
                               

TestResultDisease = db.Table('test_result_disease',
                                db.Column('test_result_id', db.Integer, db.ForeignKey('test_results.test_result_id'), primary_key=True),
                                db.Column('disease_id', db.Integer, db.ForeignKey('diseases.disease_id'), primary_key=True)
                             )