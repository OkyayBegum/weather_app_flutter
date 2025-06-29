import 'package:flutter/material.dart';
import '../core/services/weather_service.dart';
import '../models/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  Weather? get weather => _weather;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _weatherService.fetchWeather(city);
      if (data != null) {
        _weather = Weather.fromJson(data);
      } else {
        _errorMessage = 'Weather data not found.';
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch weather data.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
