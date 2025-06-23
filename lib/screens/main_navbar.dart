import 'search_screen.dart';
import 'favorites_screen.dart';
import 'about_screen.dart';
import 'reminder_screen.dart';

import 'package:flutter/material.dart';
import '../colors/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../providers/theme_provider.dart';
import '../providers/medicine_provider.dart';
import 'home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    SearchScreen(),
    FavoritesScreen(),
    ReminderScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: AppColors.accentColor.withOpacity(0.2),
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(
              fontSize: 12,
              fontFamily: 'Drug',
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : AppColors.textDark,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor:
              isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
          elevation: 0,
          height: 60,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.accentColor),
              label: Locales.string(context, 'home'),
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search, color: AppColors.accentColor),
              label: Locales.string(context, 'search'),
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_outlined),
              selectedIcon: Icon(Icons.favorite, color: AppColors.accentColor),
              label: Locales.string(context, 'favorites'),
            ),
            NavigationDestination(
              icon: Icon(Icons.access_time_outlined),
              selectedIcon: Icon(
                Icons.access_time,
                color: AppColors.accentColor,
              ),
              label: Locales.string(context, 'reminders'),
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline),
              selectedIcon: Icon(Icons.info, color: AppColors.accentColor),
              label: Locales.string(context, 'about'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize data when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicineProvider>(
        context,
        listen: false,
      ).initializeData(context);
    });
  }
}
