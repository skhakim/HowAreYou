"""HowAreYou backend: a Flask app for mental-health screening and consultations.

This module only builds the shared objects (`app`, `db`). Routes live in
`backend.routes`, business logic in `backend.services`, and the REST API
for the models in `backend.api`. `backend.run` wires everything together.
"""
from flask import Flask
from flask_cors import CORS
from flask_migrate import Migrate
from flask_session import Session
from flask_sqlalchemy import SQLAlchemy

from backend.config import Config

app = Flask(__name__)
app.config.from_object(Config)

db = SQLAlchemy(app)
migrate = Migrate(app, db, directory='backend/migrations')
cors = CORS(app)
Session(app)


@app.route('/')
def hello_world():
    return 'Hello World!'
