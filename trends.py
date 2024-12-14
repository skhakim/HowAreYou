from datetime import datetime
from flask import request
import jwt
from app import app, db
from models.export import *
import matplotlib.pyplot as plt
import os
from flask import request, jsonify, send_file

@app.route('/trends', methods=['GET'])
def trends():
    n_psychiatrists = db.session.query(Psychiatrist).count()
    n_patients = db.session.query(Patient).count()
    n_tests = db.session.query(Test).count()
    n_tests_conducted = db.session.query(TestResult).count()
    n_consultations_done = db.session.query(ConsultationRequest).filter_by(approved=True).count()
    stats = {'n_psychiatrists': n_psychiatrists, 'n_patients': n_patients, 'n_tests': n_tests,
             'n_tests_conducted': n_tests_conducted, 'n_consultations_done': n_consultations_done}
    stats = {**stats, **generate_plots()}
    return jsonify(stats)
    
    
def generate_plots():
    result = db.session.execute("""select date(submitted_at), count(*) from test_results group by date(submitted_at)""")
    result = result.mappings().all()
    plotY = []
    for dic_obj in result:
        plotY.append(dic_obj['count'])
    #Disease Grap
    result = db.session.execute("""select name, count(*)  from test_result_disease NATURAL JOIN diseases GROUP BY name""")
    result = result.mappings().all()
    diseaseX = []
    diseaseY = []
    for dic_obj in result:
        diseaseX.append(dic_obj['name'])
        diseaseY.append(dic_obj['count'])
    print(len(plotY[-30:]))
    return {'detectedLabel': diseaseX, 'detectedData': diseaseY,'totalResponseLabel' : list(range(30)), 'totalResponseData': plotY[-30:]}