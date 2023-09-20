# Weather App

A Flutter weather app that fetches weather data from a Django backend.
It currently fetches weather data for the following Kenyan cities:

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

## Getting Started

This is Flutter weather client of a backend running on a Django backend. The backend fetches weather by web scrapping [Kenya Meteorological Department](http://www.meteo.go.ke/) website.  
The backend then exposes the weather data as a REST API. The Flutter client then consumes the API and displays the weather data.  
The backend must be running for the Flutter client to work.  
To run the backend:

- Navigate to the `backend` directory
- Run

```bash
pip install -r requirements.txt # Install dependencies
python manage.py runserver # Run the server
```

To run the Flutter client:

- Navigate to the weather directory
- In the `lib/constants.dart` file, change the `weatherAPI` variable to the URL of the backend server

```dart
const String weatherAPI = "server_endpoint/all/";
```

- Get the dependencies by running `flutter pub get`

```bash
flutter pub get
```

- Run the app

```bash
flutter run
```

Hooraay! You have the app running.
