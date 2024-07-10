import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/weather.dart';

Future<List<Weather>> getWeather() async {
  try {
    var request = await http.get(Uri.parse(weatherApi));
    if (request.statusCode == 200) {
      // Request successful
      var weather1 = request.body;
      var decodedWeather = jsonDecode(weather1);

      var weatherList = <Weather>[];
      for (var w in decodedWeather) {
        var weather0 = Weather.fromJson(w);
        weatherList.add(weather0);
      }

      return weatherList;
    } else {
      // Return an error Future
      return Future.error("Error fetching weather");
    }
  } catch (e) {
    // Return an error Future
    return Future.error(e.toString());
  }
}

Future<Weather> getSpecificWeather(String city) async {
  try {
    var request = await http.get(Uri.parse("$seachWeather?city=$city"));
    if (request.statusCode == 200) {
      // Request successful
      var weather1 = request.body;
      var decodedWeather = jsonDecode(weather1);

      var weather0 = Weather.fromJson(decodedWeather);

      return weather0;
    } else {
      // Return an error Future
      return Future.error("Error fetching weather");
    }
  } catch (e) {
    // Return an error Future
    return Future.error(e.toString());
  }
}
