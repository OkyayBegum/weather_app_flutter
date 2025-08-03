class Forecast {
  final DateTime date;
  final double temp;
  final String description;
  final String iconCode;

  Forecast({
    required this.date,
    required this.temp,
    required this.description,
    required this.iconCode,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.parse(json['dt_txt']),
      temp: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
    );
  }
}
