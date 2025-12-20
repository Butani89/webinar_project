from rest_framework import serializers
from .models import Attendee

class AttendeeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Attendee
        fields = ['id', 'name', 'email', 'company', 'experience', 'date', 'image_url']
        read_only_fields = ['id', 'image_url']
