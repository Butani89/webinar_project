import pytest
from django.urls import reverse
from rest_framework import status
from webinar.models import Attendee

@pytest.mark.django_db
def test_register_attendee(client):
    url = reverse('register')
    data = {
        "name": "Test User",
        "email": "test@example.com",
        "date": "2025-12-24"
    }
    response = client.post(url, data, content_type='application/json')
    assert response.status_code == status.HTTP_201_CREATED
    assert Attendee.objects.count() == 1
    assert Attendee.objects.get().name == "Test User"

@pytest.mark.django_db
def test_list_attendees_unauthorized(client):
    url = reverse('attendees')
    response = client.get(url)
    assert response.status_code == status.HTTP_401_UNAUTHORIZED
