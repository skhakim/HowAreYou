from app import db

# many-to-many relationship TestQuestion  between Test and Question
TestQuestion = db.Table('test_question',
                        db.Column('test_id', db.Integer, db.ForeignKey('tests.test_id'), primary_key=True),
                        db.Column('question_id', db.Integer, db.ForeignKey('questions.question_id'), primary_key=True),
                        db.Column('is_approved', db.Boolean, default=False),
                        db.Column('pending_delete', db.Boolean, default=False),
                        db.Column('delete_reasoning', db.String(256))
                        )


class Test(db.Model):
    __tablename__ = 'tests'
    test_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), nullable=False)
    description = db.Column(db.String(256))
    created_at = db.Column(db.DateTime, nullable=False)
    # is_approved = db.Column(db.Boolean, default=False)
    questions = db.relationship('Question', secondary=TestQuestion, lazy='subquery'
                                , backref=db.backref('tests', lazy=True))

    # add person_id_of_added_by, disease_id
    psychiatrist_id_of_added_by = db.Column(db.Integer, db.ForeignKey('psychiatrists.psychiatrist_id'))
    # disease_id = db.Column(db.Integer, db.ForeignKey('diseases.disease_id'))
    # psychiatrists = db.relationship('Psychiatrist', backref=db.backref('tests_added_by', lazy=True))
    # disease = db.relationship('TestDisease', backref=db.backref('tests', lazy=True))


class Question(db.Model):
    __tablename__ = 'questions'
    question_id = db.Column(db.Integer, primary_key=True)
    question_text = db.Column(db.String(256))
    created_at = db.Column(db.DateTime)
    is_approved = db.Column(db.Boolean)
    options = db.relationship('Option', backref='question', lazy=True)
    # add person_id_of_added_by, disease_id


class Option(db.Model):
    __tablename__ = 'options'
    option_id = db.Column(db.Integer, primary_key=True)
    option_text = db.Column(db.String(256))
    score = db.Column(db.Integer)
    question_id = db.Column(db.Integer, db.ForeignKey('questions.question_id'))


# many-to-many relationship Answer between TestResult and Question
Answer = db.Table('answer',
                  db.Column('test_result_id', db.Integer, db.ForeignKey('test_results.test_result_id'), primary_key=True),
                  db.Column('option_id', db.Integer, db.ForeignKey('options.option_id'), primary_key=True)
                  )


class TestResult(db.Model):
    __tablename__ = 'test_results'
    test_result_id = db.Column(db.Integer, primary_key=True)
    test_id = db.Column(db.Integer, db.ForeignKey('tests.test_id'), nullable=False)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.patient_id'), nullable=False)
    submitted_at = db.Column(db.DateTime)
    verifier_id = db.Column(db.Integer, db.ForeignKey('psychiatrists.psychiatrist_id'))
    verified_at = db.Column(db.DateTime)
    machine_report = db.Column(db.String(256))
    manual_report = db.Column(db.String(256))
    # relationship with Test table
    test = db.relationship('Test')
    options = db.relationship('Option', secondary=Answer, lazy='dynamic')
    score = db.Column(db.Integer, default=0)


CounsellingSuggestion = db.Table('counselling_suggestion',
                                 db.Column('counsel_id', db.Integer, primary_key=True),
                                 db.Column('test_result_id', db.Integer, db.ForeignKey('test_results.test_result_id')),
                                 db.Column('psychiatrist_id', db.Integer, db.ForeignKey('psychiatrists.psychiatrist_id'))   #consultant
                                 )


class ConsultationRequest(db.Model):
    __tablename__ = 'consultation_request'
    consultation_request_id = db.Column(db.Integer, primary_key=True)
    counsel_id = db.Column(db.Integer,nullable=False)
    test_result_id = db.Column(db.Integer, db.ForeignKey('test_results.test_result_id'), nullable=False)
    info = db.Column(db.String(256))
    approved = db.Column(db.Boolean, default=False)
    schedule = db.Column(db.String(256))
    method = db.Column(db.String(64))
    fee = db.Column(db.Integer)
    con_time = db.Column(db.DateTime)

