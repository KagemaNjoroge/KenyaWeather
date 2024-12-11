from django.urls import path
from .views import WeatherList, TownsList


app_name = "api"

urlpatterns = [
    path("weather/", WeatherList.as_view(), name="weather_list"),
    path("towns/", TownsList.as_view(), name="towns_list"),
]
