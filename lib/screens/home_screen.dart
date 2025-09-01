import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/background_helper.dart';
import 'package:location/location.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherForCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final weather = provider.weather;
    final settings = Provider.of<SettingsProvider>(context).settings;
    final isCelsius = settings.isCelsius;

    final temperature = weather != null
        ? (isCelsius ? weather.temperature : (weather.temperature * 9 / 5) + 32)
        : 0;
    final unit = isCelsius ? '°C' : '°F';

    final backgroundImage = weather != null
        ? AssetImage(getBackgroundImage(weather.mainCondition))
        : null;

    void fakeLocationCheck() async {
      Location location = Location();
      // Sadece bu satır çalışsın yeter, izin istemez:
      var status = await location.hasPermission();
      print('İzin durumu: $status');
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: weather == null && !provider.isLoading
          ? const Center(child: Text('Veri bulunamadı.'))
          : Stack(
              fit: StackFit.expand,
              children: [
                if (backgroundImage != null)
                  Image(
                    image: backgroundImage,
                    fit: BoxFit.cover,
                  ),
                Container(color: Colors.black.withOpacity(0.3)),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFFE0E0E0), // Açık gri ton (almost white)
                              Color(0xFFFFFFFF), // Saf beyaz
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: const Text(
                            'Weather App',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        provider.isLoading
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text(
                                    'Konum alınıyor, lütfen bekleyin...',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              )
                            : Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black54
                                    : Colors.white,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Lottie.asset(
                                          getLottiePath(weather!.mainCondition),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        weather.cityName,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${temperature.toStringAsFixed(1)}$unit',
                                        style: const TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        weather.description,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _infoColumn(
                                              icon: Icons.thermostat,
                                              label: 'Feels like',
                                              value:
                                                  '${(isCelsius ? weather.feelsLike : (weather.feelsLike * 9 / 5 + 32)).toStringAsFixed(1)}$unit'),
                                          _infoColumn(
                                              icon: Icons.water_drop,
                                              label: 'Humidity',
                                              value: '${weather.humidity}%'),
                                          _infoColumn(
                                              icon: Icons.air,
                                              label: 'Wind',
                                              value:
                                                  '${weather.windSpeed.toStringAsFixed(1)} m/s'),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _infoColumn(
                                              icon: Icons.speed,
                                              label: 'Pressure',
                                              value: '${weather.pressure} hPa'),
                                          _infoColumn(
                                              icon: Icons.wb_sunny,
                                              label: 'UV Index',
                                              value:
                                                  weather.uvIndex.toString()),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Updated: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _infoColumn(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87)),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87)),
      ],
    );
  }
}
