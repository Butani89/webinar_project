from django.urls import path
from .views import RegisterAttendeeView, ListAttendeesView

urlpatterns = [
    path('register/', RegisterAttendeeView.as_view(), name='register'),
    path('attendees/', ListAttendeesView.as_view(), name='attendees'),
]
