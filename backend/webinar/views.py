import os
from django.conf import settings
from django.shortcuts import redirect
from inertia import render, share
from rest_framework import status, views, permissions
from rest_framework.response import Response
from .models import Attendee
from .serializers import AttendeeSerializer
from .utils import generate_mushroom
import logging

logger = logging.getLogger(__name__)

class IndexView(views.APIView):
    permission_classes = [permissions.AllowAny]
    
    def get(self, request):
        return render(request, 'App', props={
            'event_date': '2025-12-24',
            'speakers': [
                {
                    'name': 'Dr. M. Myceliaceae',
                    'title': 'Professor i Mykologisk Neurobiologi',
                    'desc': 'Ledande expert på svampnätverkens bio-elektriska kommunikation.',
                    'image': '/img/m.myceliaceae.jpg'
                },
                {
                    'name': 'A. Amanita',
                    'title': 'Ljuddesigner & Myko-musiker',
                    'desc': 'Pionjär inom översättning av biologiska signaler till auditiv konst.',
                    'image': '/img/a.amanita.jpg'
                }
            ],
            'new_attendee': request.session.pop('new_attendee', None)
        })

class RegisterAttendeeView(views.APIView):
    permission_classes = [permissions.AllowAny]
    authentication_classes = [] 

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
                
                request.session['new_attendee'] = AttendeeSerializer(attendee).data
                return redirect('index')
            except Exception as e:
                logger.error(f"Art generation failed: {e}")
                request.session['new_attendee'] = AttendeeSerializer(attendee).data
                return redirect('index')
        
        return render(request, 'App', props={
            'errors': serializer.errors,
            'event_date': '2025-12-24',
            'speakers': [
                {
                    'name': 'Dr. M. Myceliaceae',
                    'title': 'Professor i Mykologisk Neurobiologi',
                    'desc': 'Ledande expert på svampnätverkens bio-elektriska kommunikation.',
                    'image': '/img/m.myceliaceae.jpg'
                },
                {
                    'name': 'A. Amanita',
                    'title': 'Ljuddesigner & Myko-musiker',
                    'desc': 'Pionjär inom översättning av biologiska signaler till auditiv konst.',
                    'image': '/img/a.amanita.jpg'
                }
            ]
        })

class ListAttendeesView(views.APIView):
    def get(self, request):
        auth_header = request.headers.get('X-Admin-Password')
        if auth_header != settings.ADMIN_PASSWORD:
            return Response({"message": "Unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
            
        attendees = Attendee.objects.all().order_by('-id')
        serializer = AttendeeSerializer(attendees, many=True)
        return Response(serializer.data)
