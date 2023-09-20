from django.urls import path
from .views import all_weather
urlpatterns = [
    path('all/', all_weather, name='all_weather')

]
