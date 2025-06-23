// lib/providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _language = 'en';
  double _textSize = 1.0; // Scale factor for text size

  String get language => _language;
  double get textSize => _textSize;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'en';
    _textSize = prefs.getDouble('textSize') ?? 1.0;
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    _language = langCode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);
    notifyListeners();
  }

  Future<void> setTextSize(double size) async {
    // Constrain between 0.8 and 1.5
    _textSize = size.clamp(0.8, 1.5);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textSize', _textSize);
    notifyListeners();
  }
}
