from app import app
from models.qa_models import *

"""
    This file contains the code for the questionnaire.
    
    POST code creating test_result 
    
    POST /api/tr HTTP/1.1
    Host: example.com
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json
    
    {
      "data": {
        "type": "tr",
        "attributes": {
          "test_id": 2,
          "patient_id": 1705008,
          "submitted_at": "2022-2-1 01:00"
        },
        "relationships": {
            "options": {
                "data": [
                    {
                        "id": "101",
                        "type": "options"
                    },
                    {
                        "id": "81",
                        "type": "options"
                    },
                    {
                        "id": "92",
                        "type": "options"
                    },
                    {
                        "id": "86",
                        "type": "options"
                    },
                    {
                        "id": "96",
                        "type": "options"
                    },
                    {
                        "id": "76",
                        "type": "options"
                    },
                    {
                        "id": "68",
                        "type": "options"
                    },
                    {
                        "id": "72",
                        "type": "options"
                    }
                ]
                }
            }
        }
    }
"""


@app.route('/calculate_result/<test_result_id>', methods=['POST'])
def calculate_score(test_result_id, **kwargs):
    """
        Calculate the score of a test result.
        The score is the sum of the scores of the options.
    """
    print(test_result_id)
    test_result = TestResult.query.filter_by(test_result_id=test_result_id).first()
    score = 0
    print(test_result.options)
    for option in test_result.options:
        print(option.option_id)
        score += option.score
    test_result.score = score   # update the score in the database
    print(test_result_id, score)
    db.session.commit()
    return "OK"

