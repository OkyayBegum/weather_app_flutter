import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';

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
    // İlk ekran yüklendiğinde varsayılan şehir için veri çek
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather(_cityController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus(); // klavyeyi kapat
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
                            : const Text('No data.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
