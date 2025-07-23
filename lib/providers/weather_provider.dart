import 'package:flutter/material.dart';
import '../core/services/weather_service.dart';
import '../models/weather_model.dart';
import '../core/services/location_service.dart';


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
Future<void> fetchWeatherForCurrentLocation() async {
  _isLoading = true;
  _errorMessage = null;
  _weather = null;
  notifyListeners();

  final locationService = LocationService();
  final locationData = await locationService.getLocation();

  if (locationData != null) {
    final data = await WeatherService().fetchWeatherByCoordinates(
      locationData.latitude!,
      locationData.longitude!,
    );

    if (data != null) {
      _weather = Weather.fromJson(data);
      _errorMessage = null;
    } else {
      _errorMessage = 'Konuma göre hava durumu alinamadi.';
    }
  } else {
    _errorMessage = 'Konum bilgisi alinamadi.';
  }

  _isLoading = false;
  notifyListeners();
}
}
