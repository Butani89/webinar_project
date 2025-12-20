from django.db import models

class Attendee(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField(max_length=100)
    company = models.CharField(max_length=100, blank=True, null=True)
    experience = models.CharField(max_length=100, blank=True, null=True)
    date = models.CharField(max_length=50)
    image_url = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name
