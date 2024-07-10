from django.urls import path
from .views import all_weather, get_weather_for_specific_city

urlpatterns = [
    path("all/", all_weather, name="all_weather"),
    path(
        "specific/", get_weather_for_specific_city, name="get_weather_for_specific_city"
    ),
]
