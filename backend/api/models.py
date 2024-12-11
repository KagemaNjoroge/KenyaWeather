from django.db import models

class Weather(models.Model):
    city = models.CharField(max_length=100)
    max_temp = models.CharField(max_length=100)
    min_temp = models.CharField(max_length=100)
    description = models.CharField(max_length=100)
    date_time_fetched = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.city

    class Meta:
        verbose_name_plural = "Weather"
