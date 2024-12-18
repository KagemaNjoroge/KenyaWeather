import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../utils/weather.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  List<Weather> weather = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController townController = TextEditingController();

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
                        Icon(Icons.error, color: Colors.red),
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
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                var town = townController.text;
                var weather = await getWeather(town: town);

                print(weather);
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
}
