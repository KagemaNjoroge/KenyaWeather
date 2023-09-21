import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

void main(List<String> args) {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(useMaterial3: true),
      home: const Home(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<List<Weather>> getWeather() async {
    try {
      var request = await http.get(weatherApi);
      if (request.statusCode == 200) {
        // Request successful
        var weather1 = request.body;
        var decodedWeather = jsonDecode(weather1);

        var weatherList = <Weather>[];
        for (var w in decodedWeather) {
          var weather0 = Weather.fromJson(w);
          weatherList.add(weather0);
        }
        setState(() {
          weather = weatherList;
        });
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

  List<Weather> weather = [];

  Widget weatherCard(Weather weather) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(weather.city),
          Text(weather.weatherDescription),
          Text("Min Temp: ${weather.minTemp}"),
          Text("Max Temp: ${weather.maxTemp}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todays Weather'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
            tooltip: "Refresh Weather",
          )
        ],
      ),
      body: FutureBuilder<List<Weather>>(
        future: getWeather(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return weatherCard(snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            // an error occured

            return Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Error fetching weather"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Are you connected to the internet?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // retry fetching weather
                        setState(() {
                          weather = [];
                        });

                        getWeather();
                      },
                      child: const Text("Retry"),
                    )
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // body: Center(
      //     child: ElevatedButton(
      //   child: const Text('fetch'),
      //   onPressed: () async {
      //     var weather = await fetchWeather();
      //     for (var w in weather) {
      //       print(w.toJson());
      //     }
      //   },
      // )),
    );
  }
}

class HomeTown {
  final String townName;

  HomeTown({
    required this.townName,
  });

  factory HomeTown.fromJson(Map<String, dynamic> json) {
    return HomeTown(
      townName: json['town_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'townName': townName,
    };
  }
}

class Weather {
  final String city;
  final String weatherDescription;
  final String minTemp;
  final String maxTemp;

  Weather({
    required this.city,
    required this.weatherDescription,
    required this.minTemp,
    required this.maxTemp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // {"town_name": "Machakos", "weather_description": " Cloudy, Sunny Intervals  ", "min_temp": "13 \u02daC", "max_temp": "26 \u02daC"}
    return Weather(
      city: json['town_name'],
      weatherDescription: json['weather_description'],
      minTemp: json['min_temp'],
      maxTemp: json['max_temp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'weatherDescription': weatherDescription,
      'minTemp': minTemp,
      'maxTemp': maxTemp,
    };
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: true,
      ),
      // responsive body
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            // large screen
            return Container(
              child: const Center(
                child: Text(("Desktop/ Wide Screen")),
              ),
            );
          } else {
            // small screen, probably mobile
            return Container(
              child: const Center(
                child: Text(("Mobile")),
              ),
            );
          }
        },
      ),
    );
  }
}
