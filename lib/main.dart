// lib/main.dart
import 'package:flutter/material.dart';
import 'package:my_medicines/screens/main_navbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'providers/theme_provider.dart';
import 'providers/medicine_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/settings_provider.dart';
import 'splash_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'ar', 'fa']);

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return LocaleBuilder(
      builder:
          (locale) => MaterialApp(
            title: 'My Medicines',
            localizationsDelegates: Locales.delegates,
            supportedLocales: Locales.supportedLocales,
            locale: Locale(settingsProvider.language),
            theme: themeProvider.themeData,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            builder: (context, child) {
              // Apply text scaling factor
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(settingsProvider.textSize),
                ),
                child: child!,
              );
            },
            routes: {"/HomeScreen": (context) => HomeScreen()},
          ),
    );
  }
}
