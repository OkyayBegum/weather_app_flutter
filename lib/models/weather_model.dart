class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final String description;
  final String iconCode;
  final String mainCondition;
  final double windSpeed;
  final int pressure;
  final double uvIndex; // Şimdilik sabit değer

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.description,
    required this.iconCode,
    required this.mainCondition,
    required this.windSpeed,
    required this.pressure,
    required this.uvIndex,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];

    return Weather(
      cityName: json['name'] ?? '',
      temperature: (main['temp'] ?? 0).toDouble(),
      feelsLike: (main['feels_like'] ?? 0).toDouble(),
      humidity: (main['humidity'] ?? 0).toInt(),
      description: weather['description'] ?? '',
      iconCode: weather['icon'] ?? '',
      mainCondition: weather['main'] ?? '',
      windSpeed: (wind['speed'] ?? 0).toDouble(),
      pressure: (main['pressure'] ?? 0).toInt(),
      uvIndex: 5.0, // Dummy: Gerçek veri için farklı API çağrısı gerekir
    );
  }
}
