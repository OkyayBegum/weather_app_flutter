import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../providers/weather_provider.dart';
import '../utils/background_helper.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

String getLottiePath(String condition) {
  switch (condition.toLowerCase()) {
    case 'clear':
      return 'assets/animations/clear.json';
    case 'clouds':
      return 'assets/animations/clouds.json';
    case 'rain':
      return 'assets/animations/rain.json';
    case 'thunderstorm':
      return 'assets/animations/thunderstorm.json';
    case 'snow':
      return 'assets/animations/snow.json';
    case 'fog':
    case 'mist':
    case 'haze':
      return 'assets/animations/fog.json';
    default:
      return 'assets/animations/clear.json';
  }
}

Color getLottieBackground(String condition) {
  switch (condition.toLowerCase()) {
    case 'clouds':
    case 'snow':
    case 'fog':
      return Colors.black.withOpacity(0.15);
    default:
      return Colors.transparent;
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _cityController =
      TextEditingController(text: 'Istanbul');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<WeatherProvider>(context, listen: false);
      provider.fetchWeather(_cityController.text);
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final weather = provider.weather;
    final forecastList = provider.forecastList;

    final backgroundImage = weather != null
        ? AssetImage(getBackgroundImage(weather.mainCondition))
        : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: backgroundImage != null
              ? DecorationImage(
                  image: backgroundImage,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      '🌍 Search Weather',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _cityController,
                    style: TextStyle(color: Colors.black87),
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: 'Istanbul',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    provider.fetchWeather(_cityController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.85),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.errorMessage != null
                          ? Center(
                              child: Text(
                                provider.errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : weather != null
                              ? ListView(
                                  children: [
                                    Card(
                                      elevation: 6,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black54
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: getLottieBackground(
                                                    weather.mainCondition),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Lottie.asset(
                                                getLottiePath(
                                                    weather.mainCondition),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              weather.cityName,
                                              style: const TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${weather.temperature.toStringAsFixed(1)} °C',
                                              style: const TextStyle(
                                                fontSize: 48,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              weather.description,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Wrap(
                                              alignment:
                                                  WrapAlignment.spaceEvenly,
                                              spacing: 24,
                                              runSpacing: 16,
                                              children: [
                                                _buildInfoTile(
                                                    Icons.thermostat,
                                                    'Feels like',
                                                    '${weather.feelsLike} °C'),
                                                _buildInfoTile(
                                                    Icons.water_drop,
                                                    'Humidity',
                                                    '${weather.humidity}%'),
                                                _buildInfoTile(
                                                    Icons.air,
                                                    'Wind',
                                                    '${weather.windSpeed} m/s'),
                                                _buildInfoTile(
                                                    Icons.compress,
                                                    'Pressure',
                                                    '${weather.pressure} hPa'),
                                                _buildInfoTile(
                                                    Icons.wb_sunny,
                                                    'UV Index',
                                                    '${weather.uvIndex}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      '5-days Forecast',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    forecastList.isNotEmpty
                                        ? Column(
                                            children: forecastList.map((f) {
                                              return Card(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: ListTile(
                                                  leading: Image.network(
                                                    'https://openweathermap.org/img/wn/${f.iconCode}@2x.png',
                                                  ),
                                                  title: Text(
                                                      DateFormat('EEE, d MMM')
                                                          .format(f.date)),
                                                  subtitle: Text(
                                                    '${f.temp.toStringAsFixed(1)} °C - ${f.description}',
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          )
                                        : const Text(
                                            'Tahmin verisi yok.',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                  ],
                                )
                              : const Center(child: Text('No weather data.')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black54)),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87)),
      ],
    );
  }
}
