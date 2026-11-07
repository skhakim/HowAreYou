"""Application settings, read from environment variables.

Copy `.env.example` to `.env` for local development. Nothing secret is
hardcoded here.
"""
import os
import secrets
import warnings

from dotenv import load_dotenv

load_dotenv()  # reads .env if present


def _secret_key():
    key = os.environ.get('SECRET_KEY')
    if key:
        return key
    warnings.warn(
        'SECRET_KEY is not set; using a random key for this process. '
        'Logins will be invalidated on every restart. Set SECRET_KEY in .env.'
    )
    return secrets.token_hex(32)


class Config:
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'DATABASE_URL', 'postgresql://postgres:postgres@localhost/mhst')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = _secret_key()
    UPLOAD_FOLDER = os.environ.get('UPLOAD_FOLDER', 'uploads')

    # Google Calendar (used to create consultation events)
    GOOGLE_CREDENTIALS_FILE = os.environ.get('GOOGLE_CREDENTIALS_FILE', 'credentials.json')
    GOOGLE_TOKEN_FILE = os.environ.get('GOOGLE_TOKEN_FILE', 'token.json')
