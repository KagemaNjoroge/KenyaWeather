import 'package:flutter/material.dart';

import 'models/weather.dart';
import 'utils/weather.dart';

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
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  List<Weather> weather = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController townController = TextEditingController();

  Widget searchForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: townController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter town name",
              hintText: "e.g. Nairobi",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a town name";
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Form is valid
                // Get the weather
                // getWeather(townController.text);
              }
            },
            child: const Text("Search"),
          ),
        ],
      ),
    );
  }

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
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Search for weather"),
                    content: searchForm(),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: "Search for weather in a town",
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
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Are you connected to the internet?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
    );
  }
}
