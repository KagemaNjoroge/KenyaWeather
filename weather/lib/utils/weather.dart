import 'package:dio/dio.dart';

import '../constants.dart';
import '../models/weather.dart';

Future<List<Weather>> getWeather({String town = ""}) async {
  final dio = Dio();
  var url = town.isEmpty ? weatherApi : "$weatherApi?town=$town";
  try {
    var request = await dio.get(url);
    if (request.statusCode == 200) {
      // Request successful
      var weather = request.data;

      var weatherList = <Weather>[];
      for (var w in weather) {
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
