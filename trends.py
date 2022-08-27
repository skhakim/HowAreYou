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
    return stats
    
    
@app.route('/plots', methods=['GET'])
def get_plots():
    # if not os.path.exists(f'plots/{datetime.now().strftime("%Y-%m-%d")}.png'):
    generate_plots()
    return send_file(f'plots/{datetime.now().strftime("%Y-%m-%d")}.png')

def generate_plots():
    result = db.session.execute("""select date(submitted_at), count(*) from test_results group by date(submitted_at)""")
    result = result.mappings().all()
    plotX = []
    plotY = []
    for dic_obj in result:
        plotX.append(dic_obj['date'].strftime('%Y-%m-%d'))
        plotY.append(dic_obj['count'])
    plt.rcParams['figure.figsize'] = (20, 12)
    plt.subplot(1, 2, 1)
    plt.style.use('ggplot')
    plt.bar(plotX, plotY)
    plt.xticks(rotation=45, fontsize = 12)
    plt.ylabel('Number of\nTests Conducted',fontsize = 16)
    plt.yticks(fontsize = 14)
    plt.tight_layout()
    # plt.savefig(f'plots/{datetime.now().strftime("%Y-%m-%d")}.png')


    #Disease Graph

    result = db.session.execute("""select name, count(*)  from test_result_disease NATURAL JOIN diseases GROUP BY name""")
    result = result.mappings().all()
    plotX = []
    plotY = []
    for dic_obj in result:
        plotX.append(dic_obj['name'])
        plotY.append(dic_obj['count'])
    plt.subplot(1, 2, 2)
    plt.bar(plotX, plotY)
    plt.xticks(rotation=45, fontsize = 12)
    plt.ylabel('Number of\nPatient',fontsize = 16)
    plt.yticks(fontsize = 14)

    plt.tight_layout()
    plt.savefig(f'plots/{datetime.now().strftime("%Y-%m-%d")}.png')