from django.contrib import admin
from .models import Weather

admin.site.site_header = "Weather API Admin"
admin.site.site_title = "Weather API Admin"


@admin.register(Weather)
class WeatherAdmin(admin.ModelAdmin):
    list_display = ("city", "max_temp", "min_temp", "description", "date_time_fetched")
    list_filter = ("city", "date_time_fetched")
    search_fields = ("city", "description")
    date_hierarchy = "date_time_fetched"
    ordering = ("-date_time_fetched",)
    readonly_fields = ("date_time_fetched",)
    fieldsets = (
        (None, {"fields": ("city", "max_temp", "min_temp", "description")}),
        ("Date & Time", {"fields": ("date_time_fetched",), "classes": ("collapse",)}),
    )
    add_fieldsets = (
        (None, {"fields": ("city", "max_temp", "min_temp", "description")}),
    )
