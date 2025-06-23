// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider with ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  bool _isDarkMode = false;

  AppThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  void setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    _updateTheme();
    _saveThemeToPrefs();
    notifyListeners();
  }

  void _updateTheme() {
    if (_themeMode == AppThemeMode.system) {
      _isDarkMode =
          WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    } else {
      _isDarkMode = _themeMode == AppThemeMode.dark;
    }
  }

  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('themeMode');
    if (savedMode != null) {
      _themeMode = AppThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedMode,
        orElse: () => AppThemeMode.system,
      );
    }
    _updateTheme();
    notifyListeners();
  }

  Future<void> _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeMode.toString());
  }

  ThemeData get themeData {
    return _isDarkMode
        ? ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey[800],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey[900],
            elevation: 0,
          ),
          cardTheme: CardTheme(color: Colors.blueGrey[700], elevation: 4),
        )
        : ThemeData.light().copyWith(
          primaryColor: Colors.blue,
          appBarTheme: AppBarTheme(backgroundColor: Colors.blue, elevation: 0),
          cardTheme: CardTheme(color: Colors.white, elevation: 2),
        );
  }
}
