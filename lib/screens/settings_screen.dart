import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    final settings = provider.settings;

    return Scaffold(
      backgroundColor: settings.isDarkMode ? Colors.grey[900] : Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('App Settings'),
        backgroundColor: settings.isDarkMode ? Colors.grey[850] : Colors.lightBlueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: settings.isDarkMode,
            onChanged: (_) => provider.toggleTheme(),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Use Celsius"),
            value: settings.isCelsius,
            onChanged: (_) => provider.toggleTemperatureUnit(),
          ),
          const Divider(),
          ListTile(
            title: const Text("Language"),
            trailing: DropdownButton<String>(
              value: settings.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text("English")),
                DropdownMenuItem(value: 'tr', child: Text("Türkçe")),
              ],
              onChanged: (value) {
                if (value != null) {
                  provider.changeLanguage(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
