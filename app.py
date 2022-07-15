from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from flask_session import Session


app = Flask(__name__)
# set app config uri to postgres
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@localhost/mhst'
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@db/mhst'   #FOR SRJ

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'HahaNoSecret'
app.secret_key = 'NoSecretEither'

db = SQLAlchemy(app)
migrate = Migrate(app, db)
cors = CORS(app)
Session(app)

# Create the database tables.
# db.create_all()


@app.route('/')
def hello_world():  # put application's code here
    return 'Hello World!'


if __name__ == '__main__':
    print('Type', type(app))
    app.run()
