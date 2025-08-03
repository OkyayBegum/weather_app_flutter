import 'package:flutter/material.dart';

class AppSettings {
  final bool isDarkMode;
  final String languageCode;
  final bool isCelsius;

  AppSettings({
    required this.isDarkMode,
    required this.languageCode,
    required this.isCelsius,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    String? languageCode,
    bool? isCelsius,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
      isCelsius: isCelsius ?? this.isCelsius,
    );
  }
}

class SettingsProvider with ChangeNotifier {
  AppSettings _settings = AppSettings(
    isDarkMode: false,
    languageCode: 'en',
    isCelsius: true,
  );

  AppSettings get settings => _settings;

  void toggleTheme() {
    _settings = _settings.copyWith(isDarkMode: !_settings.isDarkMode);
    notifyListeners();
  }

  void toggleTemperatureUnit() {
    _settings = _settings.copyWith(isCelsius: !_settings.isCelsius);
    notifyListeners();
  }

  void changeLanguage(String langCode) {
    _settings = _settings.copyWith(languageCode: langCode);
    notifyListeners();
  }
}
