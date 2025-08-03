import 'package:flutter/material.dart';
import '../core/services/weather_service.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../core/services/location_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  Weather? get weather => _weather;

  List<Forecast> _forecastList = [];
  List<Forecast> get forecastList => _forecastList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final weatherData = await _weatherService.fetchWeather(city);
      final forecastData = await _weatherService.fetchFiveDayForecast(city);

      if (weatherData != null) {
        _weather = Weather.fromJson(weatherData);
      } else {
        _errorMessage = 'Weather data not found.';
      }

      if (forecastData != null) {
        _forecastList = forecastData
            .where((item) => item['dt_txt'].contains('12:00:00'))
            .map<Forecast>((item) => Forecast.fromJson(item))
            .toList();
      } else {
        _forecastList = [];
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch weather data.';
      _forecastList = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchWeatherForCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    _weather = null;
    notifyListeners();

    try {
      final locationService = LocationService();
      final locationData = await locationService.getLocation();

      if (locationData != null) {
        final data = await _weatherService.fetchWeatherByCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        );

        if (data != null) {
          _weather = Weather.fromJson(data);
        } else {
          _errorMessage = 'Konuma göre hava durumu alınamadı.';
        }
      } else {
        _errorMessage = 'Konum bilgisi alınamadı.';
      }
    } catch (e) {
      _errorMessage = 'Konuma göre veri alınamadı.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
