import pytest
from django.urls import reverse

@pytest.mark.django_db
def test_index_view_uses_inertia(client):
    url = reverse('index')
    response = client.get(url)
    assert response.status_code == 200
    # Check if Inertia-Django rendered the correct component
    assert 'component' in response.context
    assert response.context['component'] == 'App'
    assert response.context['props']['event_date'] == '2025-12-24'
