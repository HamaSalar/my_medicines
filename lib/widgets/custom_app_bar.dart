// lib/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      elevation: 0,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      actions:
          actions ??
          [
            // Theme mode toggle button
            IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                // Toggle between light and dark mode
                themeProvider.setThemeMode(
                  themeProvider.isDarkMode
                      ? AppThemeMode.light
                      : AppThemeMode.dark,
                );
              },
            ),
          ],
    );
  }
}
