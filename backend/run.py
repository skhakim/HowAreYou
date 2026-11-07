"""Entry point: `python -m backend.run` from the repository root."""
import os

from backend import app, db
from backend import api, routes  # noqa: F401  (importing registers routes and the REST API)

if __name__ == '__main__':
    db.create_all()
    app.run(debug=os.environ.get('FLASK_DEBUG') == '1', host='0.0.0.0')
