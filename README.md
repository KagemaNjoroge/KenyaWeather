# Weather App

A Weather Data Scrapping Utility with an API.

This project is a simple weather data scrapping utility that scrapes weather data from the [Kenya Meteorological Department](http://www.meteo.go.ke/) website and provides it as a REST API. The API can be consumed by a mobile application to display the weather data.

I have used Django for the backend and Flutter for the frontend.

## description

This application consists of a **Django backend** and a **Flutter frontend**. The backend is a REST API that provides weather data for a given city. The frontend is a mobile application that displays the weather data.

## installation / setup

- Clone the repository
- Create a virtual environment and activate it

```bash
python3 -m venv venv
source venv/bin/activate
cd backend
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

## API Docs

Let's assume the server is running on `localhost:8000`

The docs for the api can be accessed at `http://localhost:8000/docs/`

- `/weather/` - This endpoint returns all the weather data scraped from the Kenya Meteorological Department website.
- `/weather?city=Nairobi` - This endpoint returns the weather data for a given city. The city name is passed as a query parameter.

## skills learnt

- Django
- Django Rest Framework
- Web Scraping - [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/) and [requests](https://requests.readthedocs.io/en/latest/) libraries
- Flutter - making API calls with Dio and displaying data in a ListView

## screenshots

The screenshot below displays the weather data as displayed on the Kenya Meteorological Department website.

![Kenya Meteorological Department Website](backend/api/utils/screenshots/img3.png)
