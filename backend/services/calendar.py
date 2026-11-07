"""Google Calendar integration for consultation events.

The OAuth flow used to run at import time, which made the whole app fail to
start without credentials. The service is now created lazily, the first time
an event is actually created.
"""
import os
from datetime import timedelta

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

from backend import app

# If you change the scopes, delete the token file so it is re-issued.
SCOPES = ['https://www.googleapis.com/auth/calendar']

_service = None


def _load_credentials():
    token_file = app.config['GOOGLE_TOKEN_FILE']
    creds = None
    if os.path.exists(token_file):
        creds = Credentials.from_authorized_user_file(token_file, SCOPES)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                app.config['GOOGLE_CREDENTIALS_FILE'], SCOPES)
            creds = flow.run_local_server(port=0)
        with open(token_file, 'w') as token:
            token.write(creds.to_json())
    return creds


def get_calendar_service():
    """Return a cached Google Calendar API client, authorizing on first use."""
    global _service
    if _service is None:
        _service = build('calendar', 'v3', credentials=_load_credentials())
    return _service


def create_event(start, desc, email1, email2):
    """Create a one-hour consultation event (times are Asia/Dhaka, UTC+6)."""
    service = get_calendar_service()
    start = start + timedelta(hours=6)
    end = (start + timedelta(hours=1)).isoformat()

    service.events().insert(
        calendarId='primary',
        body={
            "summary": 'Psychiatrist Consultation',
            "description": desc,
            "start": {"dateTime": start.isoformat(), "timeZone": 'Asia/Dhaka'},
            "end": {"dateTime": end, "timeZone": 'UTC+0600'},
            'attendees': [{'email': email2}, {'email': email1}],
            'reminders': {'useDefault': True},
        },
    ).execute()
