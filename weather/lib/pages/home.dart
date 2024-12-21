import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/settings.dart';
import 'package:weather/providers/home_town.dart';

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
        title: const Text('Weather App'),
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
                      TextButton.icon(
                        onPressed: () async {
                          var town = townController.text;

                          try {
                            var weather = await getWeather(town: town);
                            // shoow weather data
                            setState(() {
                              this.weather = weather;
                            });
                          } catch (e) {
                            // show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error fetching weather: $e"),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.search),
                        label: const Text("Search"),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: "Search for weather in a town",
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SettingsPage();
              }));
            },
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
          )
        ],
      ),
      body: Column(
        children: [
          Provider.of<HomeTownProvider>(context).homeTown.isEmpty
              ? const SizedBox()
              : Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          iconSize: 20,
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              "Home town: ${Provider.of<HomeTownProvider>(context).homeTown}"),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // max and min temp
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.thermostat),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Min Temp: 20"),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.thermostat),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Max Temp: 30"),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          Expanded(
            child: FutureBuilder<List<Weather>>(
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
          ),
        ],
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
        ],
      ),
    );
  }

  Widget weatherCard(Weather weather) {
    return Container(
      width: 100,
      height: 200,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
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
