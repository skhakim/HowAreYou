"""Importing this package registers every route on the Flask app."""
from backend.routes import (  # noqa: F401
    auth,
    consultations,
    file_requests,
    notifications,
    questionnaire,
    scoring,
    test_reports,
    trends,
)
