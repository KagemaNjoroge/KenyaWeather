from django.http import HttpRequest, HttpResponse
from django.shortcuts import render
from .utils.scrapper import get_weather
# json response
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt


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
        weather = get_weather()

        return JsonResponse(weather, safe=False)
    else:
        # wrong request method
        return HttpResponse(status=405, reason='Method Not Allowed')
