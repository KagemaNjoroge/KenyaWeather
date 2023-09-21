from django.http import HttpRequest, HttpResponse
from django.shortcuts import render
from .utils.scrapper import get_weather
# json response
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import Weather
import time


@csrf_exempt
def all_weather(request: HttpRequest) -> JsonResponse:
    '''
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

    '''
    if request.method == 'GET':
        #     # weather = get_weather()

        #     # return JsonResponse(weather, safe=False)
        # else:
        #     # wrong request method
        #     return HttpResponse(status=405, reason='Method Not Allowed')

        # check if weather data in the database exceeds 3 hours

        # if yes, fetch new data from the web, clear the database and save the new data
        weather = Weather.objects.all()
        if weather:
            # current time - last fetch time
            time_diff_between_now_and_last_fetch = time.time(
            ) - weather[0].date_time_fetched.timestamp()
            if time_diff_between_now_and_last_fetch > 10800:
                for weather in weather:
                    weather.delete()
                weather = get_weather()
                for weather_data in weather:
                    w = Weather(
                        city=weather_data['city'],
                        max_temp=weather_data['max_temp'],
                        min_temp=weather_data['min_temp'],
                        description=weather_data['description'],

                    )
                    w.save()
                return JsonResponse(weather, safe=False)
        else:
            weather = get_weather()
            for weather_data in weather:
                w = Weather(
                    city=weather_data['city'],
                    max_temp=weather_data['max_temp'],
                    min_temp=weather_data['min_temp'],
                    description=weather_data['description'],

                )
                w.save()
            return JsonResponse(weather, safe=False)
