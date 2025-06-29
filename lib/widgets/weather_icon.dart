import 'package:flutter/material.dart';

class WeatherConditionIcon extends StatelessWidget {
  final String condition;

  const WeatherConditionIcon({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    IconData icon;

    switch (condition.toLowerCase()) {
      case 'clear':
        icon = Icons.wb_sunny;
        break;
      case 'clouds':
        icon = Icons.cloud;
        break;
      case 'rain':
      case 'drizzle':
      case 'showers':
        icon = Icons.umbrella;
        break;
      case 'snow':
        icon = Icons.ac_unit;
        break;
      case 'thunderstorm':
        icon = Icons.flash_on;
        break;
      case 'mist':
      case 'fog':
      case 'haze':
        icon = Icons.blur_on; // veya Icons.waves gibi sisli bir şey
        break;
      default:
        icon = Icons.wb_cloudy;
    }

    return Icon(
      icon,
      size: 80,
      color: Colors.orangeAccent,
    );
  }
}
