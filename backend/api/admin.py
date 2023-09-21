from django.contrib import admin
from .models import Weather

# Register your models here.
admin.site.register(Weather)
# change the title of the admin site
admin.site.site_header = 'Weather API Admin'
admin.site.site_title = 'Weather API Admin'
