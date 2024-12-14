from enum import unique
from app import db



# extend db.Model to create Person with name, email, password_hash, dob, gender, phone_number, photo_path, and role
#
class Person(db.Model):
    __tablename__ = 'persons'
    person_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64))
    email = db.Column(db.String(64), unique = True)
    password_hash = db.Column(db.String(256))
    date_of_birth = db.Column(db.DateTime)
    gender = db.Column(db.String(1))
    photo_path = db.Column(db.String(128))
    cellphone = db.Column(db.String(12))
    role = db.Column(db.String(12))


class Patient(Person):
    __tablename__ = 'patients'
    height_inches = db.Column(db.Integer)
    weight_kgs = db.Column(db.Integer)
    location = db.Column(db.String)
    patient_id = db.Column(db.Integer, db.ForeignKey('persons.person_id'), primary_key=True) # foreign key to person_id
    # patient = db.relationship('Person', backref=db.backref('patient', uselist=False))


class Psychiatrist(Person):
    __tablename__ = 'psychiatrists'
    psychiatrist_id = db.Column(db.Integer, db.ForeignKey('persons.person_id'), primary_key=True) # foreign key to person_id
    # psychiatrist = db.relationship('Person', backref=db.backref('psychiatrist', uselist=False))
    is_verified = db.Column(db.Boolean, default=False)
    available_times = db.Column(db.String(256))
    certificate_id = db.Column(db.String(32))
    fee = db.Column(db.Integer)


class ReviewBoardMember(Psychiatrist):
    __tablename__ = 'review_board_member'
    board_member_id = db.Column(db.Integer, db.ForeignKey('psychiatrists.psychiatrist_id'), primary_key=True) # foreign key to psychiatrist_id
    joined_as_board_member = db.Column('joined_as_board_member', db.DateTime)

class Award(db.Model):
    __tablename__ = 'awards'
    award_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64))
    host = db.Column(db.String(256))


class Degree(db.Model):
    __tablename__ = 'degrees'
    degree_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64))
    institution = db.Column(db.String(256))


# PsychiatristAward = db.Table('psychiatrist_award',
#                                 db.Column('psychiatrist_id', db.Integer, db.ForeignKey('psychiatrists.psychiatrist_id'), primary_key=True),
#                                 db.Column('award_id', db.Integer, db.ForeignKey('awards.award_id'), primary_key=True)
#                              )

class PsychiatristAward(db.Model):
    __tablename__ = 'psychiatrist_award'
    psychiatrist_id = db.Column(db.Integer, db.ForeignKey('psychiatrists.psychiatrist_id'), primary_key=True) # foreign key to psychiatrist_id
    award_id = db.Column(db.Integer, db.ForeignKey('awards.award_id'), primary_key=True) # foreign key to award_id


# PsychiatristDegree = db.Table('psychiatrist_degree',
#                                 db.Column('psychiatrist_id', db.Integer, db.ForeignKey('psychiatrists.psychiatrist_id'), primary_key=True),
#                                 db.Column('degree_id', db.Integer, db.ForeignKey('degrees.degree_id'), primary_key=True)
#                               )

class PsychiatristDegree(db.Model):
    __tablename__ = 'psychiatrist_degree'
    psychiatrist_id = db.Column(db.Integer, db.ForeignKey('psychiatrists.psychiatrist_id'), primary_key=True) # foreign key to psychiatrist_id
    degree_id = db.Column(db.Integer, db.ForeignKey('degrees.degree_id'), primary_key=True) # foreign key to degree_id


class Role(db.Model):
    __tablename__ = 'roles'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), unique=True)

    def __repr__(self):
        return '<Role %r>' % self.name
