from django.urls import path
from .views import WeatherList


app_name = "api"

urlpatterns = [
    path("weather/", WeatherList.as_view(), name="weather_list"),
]
