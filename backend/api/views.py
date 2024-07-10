import stat
from rest_framework.request import Request
from .utils.scrapper import get_weather
from .serializers import WeatherSerializer
from .models import Weather
import time
from rest_framework.decorators import api_view
from rest_framework.response import Response


@api_view(["GET"])
def all_weather(request):
    """
    Returns all weather data, currently only for Kenya.
    Supported towns/cities are:
    - Nairobi
    - Mombasa
    - Kisumu
    - Eldoret
    - Nakuru
    - Nyeri
    - Marsabit
    - Kakamega
    - Lamu
    - Garissa
    - Lodwar
    - Makindu
    - Malindi
    - Mandera
    - Voi
    - Moyale
    - Wajir
    - Kericho
    - Narok
    - Kitale
    - Meru
    - Kisii
    - Machakos

    """

    # check if weather data in the database exceeds 3 hours
    # if yes, fetch new data from the web, clear the database and save the new data
    weather = Weather.objects.all()

    # current time - last fetch time
    try:
        time_diff_between_now_and_last_fetch = (
            time.time() - weather[0].date_time_fetched.timestamp()
        )
    except:
        time_diff_between_now_and_last_fetch = 10801

    if time_diff_between_now_and_last_fetch > 10800:
        # first try connecting to the web, if successful, clear the database and save the new data
        try:
            weather = get_weather()
            Weather.objects.all().delete()
            for w in weather:
                serializer = WeatherSerializer(data=w)
                if serializer.is_valid():
                    serializer.save()
            weather = Weather.objects.all()
            serializer = WeatherSerializer(weather, many=True)
            return Response(serializer.data)

        except:
            # fall back to the database
            weather = Weather.objects.all()
            serializer = WeatherSerializer(weather, many=True)
            return Response(serializer.data)
    else:
        # return data in the database
        weather = Weather.objects.all()
        serializer = WeatherSerializer(weather, many=True)
        return Response(serializer.data)


@api_view(["GET"])
def get_weather_for_specific_city(request: Request):
    query_city = request.query_params.get("city", None)
    if query_city:
        weather = Weather.objects.filter(city__iexact=query_city)
        serializer = WeatherSerializer(weather, many=True)
        return Response(serializer.data)
    else:
        return Response({"error": "Please provide a city name"}, status=400)
