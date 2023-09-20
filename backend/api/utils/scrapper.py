from bs4 import BeautifulSoup
import requests

url = 'https://meteo.go.ke/forecast/todays-weather'

div_class = 'views-row'

town_name_class = 'views-field views-field-field-town'
weather_symbol_class = 'views-field views-field-field-symbol-1'
weather_decription_class = 'views-field views-field-nothing'


def get_weather() -> dict:
    req = requests.get(url)

    if req.status_code == 200:
        soup = BeautifulSoup(req.text, 'html.parser')

        weather = []

        for div in soup.find_all('div', class_=div_class):
            town_name = div.find('div', class_=town_name_class).text

            weather_description = div.find(
                'div', class_=weather_decription_class).text
            # {'town_name': 'Nairobi', 'weather_symbol': '', 'weather_description': 'Cloudy, Sunny Intervals\n\nTemperature\n\n\n\n\n\nMin: 15 ˚C\nMax: 27 ˚C'}
            description, min_temp_max_temp, _ = weather_description.split(
                '\n\n\n\n\n\n')
            description = description.replace('\n', ' ').strip('Temperature')

            min_temp_max_temp = min_temp_max_temp.replace(
                '\n', '')  # Min: 15 ˚CMax: 27 ˚C
            min_temp = min_temp_max_temp.split(
                'Max:')[0].strip('Min: ')  # 15 ˚C
            max_temp = min_temp_max_temp.split('Max:')[1].strip(' ')  # 27 ˚C

            weather.append({
                'town_name': town_name.strip().replace('\n', ''),

                'weather_description': description,
                'min_temp': min_temp,
                'max_temp': max_temp,
            })

        return weather

    else:
        return {'error': 'Something went wrong'}
