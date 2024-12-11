from rest_framework import serializers
from .models import Weather

from rest_framework.serializers import Serializer, CharField


class SupportedTownsSerializer(Serializer):
    city = CharField()

    class Meta:
        model = Weather
        fields = ["city"]


class WeatherSerializer(serializers.ModelSerializer):
    class Meta:
        model = Weather
        fields = "__all__"
        read_only_fields = ["date_time_fetched"]
