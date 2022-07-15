from app import app
from qa_models import *

"""

    This file contains the code for the questionnaire.
    
    POST code creating test_result 
    
    POST /api/tr HTTP/1.1
    Host: example.com
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json
    
    {
      "data": {
        "type": "person",
        "attributes": {
          "test_id": 2,
          "patient_id": 1705016,
        }
      }
    }
    
    {
      "data": {
        "type": "tr",
        "attributes": {
          "test_id": 2,
          "patient_id": 1705017,
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
                        "id": "91",
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