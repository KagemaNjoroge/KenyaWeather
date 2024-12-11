from .utils.scrapper import get_weather
from .serializers import SupportedTownsSerializer, WeatherSerializer
from .models import Weather
import time
from rest_framework.generics import ListAPIView


class TownsList(ListAPIView):
    """
    Returns a list of all towns/cities supported by the API
    """

    serializer_class = SupportedTownsSerializer

    def get_queryset(self):
        return Weather.objects.all().values("city").distinct()


class WeatherList(ListAPIView):
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

    queryset = Weather.objects.all()
    serializer_class = WeatherSerializer

    # filtering support
    filterset_fields = (
        "city",
        "max_temp",
        "min_temp",
        "description",
        "date_time_fetched",
    )

    def get_queryset(self):
        """
        check if weather data in the database exceeds 3 hours
        if yes, fetch new data from the web, clear the database and save the new data
        """

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
                return weather

            except:
                # fall back to the database
                weather = Weather.objects.all()
                return weather
        else:
            # return data in the database
            weather = Weather.objects.all()
            return weather
