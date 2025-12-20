from django.urls import path
from .views import IndexView, RegisterAttendeeView, ListAttendeesView

urlpatterns = [
    path('', IndexView.as_view(), name='index'),
    path('register/', RegisterAttendeeView.as_view(), name='register'),
    path('attendees/', ListAttendeesView.as_view(), name='attendees'),
]
