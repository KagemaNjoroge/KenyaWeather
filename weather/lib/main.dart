import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/brightness.dart';
import 'package:weather/providers/home_town.dart';

import 'pages/home.dart';

void main(List<String> args) {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BrightnessProvider(),
        ),
        ChangeNotifierProvider(create: (context) => HomeTownProvider()),
      ],
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        brightness: Provider.of<BrightnessProvider>(context).brightness,
      ),
      home: const WeatherPage(),
    );
  }
}
