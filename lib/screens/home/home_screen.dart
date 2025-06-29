import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: weatherProvider.isLoading
            ? const CircularProgressIndicator()
            : weatherProvider.errorMessage != null
                ? Text('Error: ${weatherProvider.errorMessage}')
                : weatherProvider.weather != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weatherProvider.weather!.cityName,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${weatherProvider.weather!.temperature} °C',
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            weatherProvider.weather!.description,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          weatherProvider.fetchWeather('Istanbul');
                        },
                        child: const Text('Load Weather'),
                      ),
      ),
    );
  }
}
