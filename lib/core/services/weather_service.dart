import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = '307d188b948330d12c1601331cfc1593';

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';

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
}
