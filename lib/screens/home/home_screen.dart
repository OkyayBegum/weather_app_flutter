import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import '../../widgets/weather_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController(text: 'Istanbul');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather(_cityController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                weatherProvider.fetchWeather(_cityController.text.trim());
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: weatherProvider.isLoading
                    ? const CircularProgressIndicator()
                    : weatherProvider.errorMessage != null
                        ? Text(
                            weatherProvider.errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          )
                        : weatherProvider.weather != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WeatherConditionIcon(
                                    condition: weatherProvider.weather!.mainCondition,
                                  ),
                                  Text(
                                    weatherProvider.weather!.cityName,
                                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${weatherProvider.weather!.temperature} °C',
                                    style: const TextStyle(fontSize: 48),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    weatherProvider.weather!.description,
                                    style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                                  ),
                                ],
                              )
                            : const Text('No weather data.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
