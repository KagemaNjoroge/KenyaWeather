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
    return Weather(
      city: json['city'],
      weatherDescription: json['description'],
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
