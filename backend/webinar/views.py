import os
from django.conf import settings
from rest_framework import status, views, permissions
from rest_framework.response import Response
from .models import Attendee
from .serializers import AttendeeSerializer
from .utils import generate_mushroom
import logging

logger = logging.getLogger(__name__)

class RegisterAttendeeView(views.APIView):
    permission_classes = [permissions.AllowAny]
    authentication_classes = [] # Public endpoint, no session/token required

    def post(self, request):
        serializer = AttendeeSerializer(data=request.data)
        if serializer.is_valid():
            attendee = serializer.save()
            
            try:
                # Setup media path for mushroom art
                image_filename = f"attendee_mushroom_{attendee.id}.png"
                relative_path = os.path.join('attendees', image_filename)
                absolute_path = os.path.join(settings.MEDIA_ROOT, relative_path)
                
                os.makedirs(os.path.dirname(absolute_path), exist_ok=True)
                generate_mushroom(attendee.id, absolute_path)
                
                attendee.image_url = os.path.join(settings.MEDIA_URL, relative_path)
                attendee.save()
                
                return Response(AttendeeSerializer(attendee).data, status=status.HTTP_201_CREATED)
            except Exception as e:
                logger.error(f"Art generation failed: {e}")
                return Response(AttendeeSerializer(attendee).data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ListAttendeesView(views.APIView):
    def get(self, request):
        auth_header = request.headers.get('X-Admin-Password')
        if auth_header != settings.ADMIN_PASSWORD:
            return Response({"message": "Unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
            
        attendees = Attendee.objects.all().order_by('-id')
        serializer = AttendeeSerializer(attendees, many=True)
        return Response(serializer.data)
