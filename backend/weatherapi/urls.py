from django.contrib import admin
from django.urls import path, include
from drf_yasg.views import get_schema_view
from drf_yasg import openapi


schema_view = get_schema_view(
    openapi.Info(
        title="Weather API",
        default_version="v1",
        description="A simple weather API",
        terms_of_service="https://www.google.com/policies/terms/",
        contact=openapi.Contact(email="nyamburanjorogejames@students.uonbi.ac.ke"),
        license=openapi.License(name="BSD License"),
    ),
    public=True,
)

urlpatterns = [
    path("admin/", admin.site.urls),
    # swagger documentation
    path(
        "docs/",
        schema_view.with_ui("swagger", cache_timeout=0),
        name="schema-swagger-ui",
    ),
    path("", include("api.urls")),
]
