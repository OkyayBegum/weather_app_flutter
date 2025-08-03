import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = '307d188b948330d12c1601331cfc1593';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Şehir adına göre anlık hava durumu
  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url = '$baseUrl/weather?q=$city&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Request error: $e');
      return null;
    }
  }

  // Koordinatlara göre anlık hava durumu
  Future<Map<String, dynamic>?> fetchWeatherByCoordinates(
      double latitude, double longitude) async {
    final url =
        '$baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Request error: $e');
      return null;
    }
  }

  // ✅ Şehir adına göre 5 günlük hava tahmini
  Future<List<dynamic>?> fetchFiveDayForecast(String city) async {
    final url = '$baseUrl/forecast?q=$city&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['list']; // forecast verisi buradan gelir
      } else {
        print('Forecast API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Forecast Request Error: $e');
      return null;
    }
  }
}

