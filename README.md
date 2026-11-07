# HowAreYou

A mental-health screening and telepsychiatry platform. Patients take validated
questionnaires, psychiatrists review the results and answer with a verified
report, and patients can request consultations that are scheduled on Google
Calendar. A review board of psychiatrists approves new psychiatrists and
changes to the question bank.

**Demo video:** [Google Drive](https://drive.google.com/file/d/1qRZEMeNDTbG5MLrCW151BLsM-ojCRyn1/view?usp=sharing)
(too large for GitHub).

## Features

- Patient and psychiatrist sign-up, with review-board approval for psychiatrists
- Questionnaires with scoring and disease detection
- Anonymous (pseudonymised) test responses for psychiatrist review, with verified reports
- Consultation requests, appointments and Google Calendar events
- Question bank management with an approval workflow
- File requests and uploads between psychiatrists and patients
- In-app notifications and a platform trends page

## Project layout

```
backend/                  Flask API (run from the repo root as a package)
  __init__.py             Flask app, db, CORS and session setup
  config.py               Settings read from environment variables
  api.py                  REST API for the models (Flask-Restless-NG)
  run.py                  Entry point: python -m backend.run
  models/                 SQLAlchemy models
  routes/                 HTTP endpoints, one module per feature
    auth.py               login, signup, profile, psychiatrist approval
    questionnaire.py      add/delete/review questions
    scoring.py            score a submitted questionnaire
    test_reports.py       test responses and verified reports
    consultations.py      consultation requests and appointments
    notifications.py      in-app notifications
    file_requests.py      file requests and uploads
    trends.py             platform statistics
  services/               Logic shared by routes
    auth.py               token decorators, login/signup helpers
    calendar.py           Google Calendar client (lazy)
    pseudonyms.py         patient pseudonyms
    test_reports.py       queries behind the report screens
  scripts/data_generator.py   Fake data for development
  migrations/             Alembic migrations (Flask-Migrate)
frontend/                 React app (Create React App)
db/backup.sql             Database dump used to seed Docker
docs/                     Sample images and the demo-video link
tools/calendar-quickstart Standalone Node script from Google's quickstart
```

## Getting started

### 1. Configure

```bash
cp .env.example .env
python -c "import secrets; print(secrets.token_hex(32))"   # paste into SECRET_KEY
```

`.env` is git-ignored. Never commit it, `credentials.json` or `token.json`.

### 2. Run with Docker

```bash
docker compose up --build
```

The API is on <http://localhost:8001> and Postgres on port 5433. On first start
the database is seeded from `db/backup.sql`.

### 3. Or run locally

```bash
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
# start Postgres with a database named `mhst` and set DATABASE_URL in .env
python -m backend.run
```

Frontend:

```bash
cd frontend
yarn install
yarn start
```

### Google Calendar (optional)

Consultation events use the Google Calendar API. Create an OAuth client in
Google Cloud Console, download it as `credentials.json` into the repo root, and
the first time an event is created a browser window will ask you to authorize.
The app starts fine without these files.

### Database migrations

```bash
flask --app backend.run db migrate -m "describe change"
flask --app backend.run db upgrade
```

### Fake data

```bash
python -m backend.scripts.data_generator 100   # 100 verified test results
```

### Backups

```bash
docker ps                                                  # find the postgres container id
docker exec <id> pg_dump -U postgres mhst > db/backup.sql  # container must be running
cat db/backup.sql | docker exec -i <id> psql -U postgres   # restore
psql -h localhost -p 5433 -U postgres -d mhst              # connect to the Docker database
```

## Notes

- `docs/legacy/db.json` is an old copy of the json-server mock; the frontend uses `frontend/db.json`.
