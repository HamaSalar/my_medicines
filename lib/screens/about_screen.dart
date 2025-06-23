// lib/screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import for URL launching
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import 'feedback_screen.dart';
import '../colors/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // URL launcher method
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool isDarkMode = themeProvider.isDarkMode;
    // Preserve the specified colors
    final primaryColor = Color(0xFF1A3A6E); // Deep navy blue
    final accentColor = Color(0xFFB8860B); // Academic gold

    final surfaceColor =
        Theme.of(context).brightness == Brightness.light
            ? Color(0xFFF5F7FA)
            : Color(0xFF1E1E1E);
    final textColor =
        Theme.of(context).brightness == Brightness.light
            ? Color(0xFF2D3748)
            : Colors.white;
    final subtitleColor =
        Theme.of(context).brightness == Brightness.light
            ? Color(0xFF718096)
            : Color(0xFFACACAC);
    final dividerColor = primaryColor.withOpacity(0.12);

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // App Bar with gradient background
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: LocaleText(
                'settings',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Drug',
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [primaryColor.withOpacity(0.8), primaryColor],
                  ),
                ),
                child: Stack(
                  children: [
                    // Pattern overlay
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.07,
                        child: Image.asset(
                          'assets/images/logo.jpg', // Or a pattern background
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => SizedBox(),
                        ),
                      ),
                    ),
                    // App info centered
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/logo.jpg',
                                  height: 58,
                                  width: 58,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.medical_services,
                                      size: 28,
                                      color: primaryColor,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          LocaleText(
                            'mymedicines',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              fontFamily: 'Drug',
                            ),
                          ),
                          SizedBox(height: 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'v${AppConstants.appVersion}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Language Section
                  _buildSectionTitle(
                    context,
                    'languagepreferences',
                    Icons.language,
                    primaryColor,
                    textColor,
                  ),
                  SizedBox(height: 16),
                  _buildLanguageSelector(
                    context,
                    settingsProvider,
                    surfaceColor: surfaceColor,
                    primaryColor: primaryColor,
                    accentColor: accentColor,
                    textColor: textColor,
                  ),

                  SizedBox(height: 24),

                  // Text Size Section
                  _buildSectionTitle(
                    context,
                    'textsize',
                    Icons.text_fields,
                    primaryColor,
                    textColor,
                  ),
                  SizedBox(height: 16),
                  _buildTextSizeSelector(
                    context,
                    settingsProvider,
                    surfaceColor: surfaceColor,
                    primaryColor: primaryColor,
                    accentColor: accentColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),

                  SizedBox(height: 24),

                  // Theme Mode Section
                  _buildSectionTitle(
                    context,
                    'appearance',
                    Icons.palette,
                    primaryColor,
                    textColor,
                  ),
                  SizedBox(height: 16),
                  _buildThemeModeSelector(
                    context,
                    themeProvider,
                    surfaceColor: surfaceColor,
                    primaryColor: primaryColor,
                    accentColor: accentColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),

                  SizedBox(height: 5),

                  // Footer
                  Divider(color: dividerColor, thickness: 1),
                  // SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // SizedBox(width: 20),
                      _buildContactInfo(
                        context,
                        surfaceColor: surfaceColor,
                        primaryColor: primaryColor,
                        accentColor: accentColor,
                        textColor: textColor,
                        subtitleColor: subtitleColor,
                      ),
                      // SizedBox(width: 20),
                      _buildFooter(
                        context,
                        primaryColor: primaryColor,
                        accentColor: accentColor,
                        subtitleColor: subtitleColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _buildFeedbackButton(
                      context,
                      surfaceColor: surfaceColor,
                      primaryColor: primaryColor,
                      accentColor: accentColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Contact Information section that opens dialog when clicked
  Widget _buildContactInfo(
    BuildContext context, {
    required Color surfaceColor,
    required Color primaryColor,
    required Color accentColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return GestureDetector(
      onTap:
          () => _showContactDialog(
            context,
            primaryColor,
            accentColor,
            subtitleColor,
            textColor,
            surfaceColor,
          ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDarkMode ? Colors.white : Colors.black),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.contact_phone,
              size: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            SizedBox(width: 8),
            LocaleText(
              'contact_us',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white : Colors.black,
                fontFamily: 'Drug',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  // Show contact dialog with all contact information
  void _showContactDialog(
    BuildContext context,
    Color primaryColor,
    Color accentColor,
    Color subtitleColor,
    Color textColor,
    Color surfaceColor,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with contact icon
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.contact_phone,
                      size: 30,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Title
                  LocaleText(
                    'contact_us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? primaryColor
                              : Colors.white,
                      fontFamily: 'Drug',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8),
                  // Divider with accent color
                  Divider(color: accentColor, thickness: 0.8),
                  SizedBox(height: 16),

                  // Store Hours
                  _buildDialogContactItem(
                    icon: Icons.access_time,
                    title: Locales.string(context, 'store_opening_hours'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocaleText(
                          'saturday_thursday',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                            fontFamily: 'Drug',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '12:00 am - 6:00 pm',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Drug',
                          ),
                        ),
                      ],
                    ),
                    primaryColor: primaryColor,
                    onTap: null,
                  ),

                  SizedBox(height: 16),
                  Divider(color: primaryColor.withOpacity(0.1)),

                  SizedBox(height: 16),

                  // Phone Numbers
                  _buildDialogContactItem(
                    icon: Icons.phone,
                    title: 'T1:',
                    content: Text(
                      '+9647700850705',
                      style: TextStyle(
                        fontSize: 14,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    primaryColor: primaryColor,
                    onTap: () {
                      _launchUrl('tel:+9647700850705');
                      Navigator.of(context).pop(); // Close dialog after action
                    },
                  ),

                  SizedBox(height: 12),

                  _buildDialogContactItem(
                    icon: Icons.phone_outlined,
                    title: 'T2:',
                    content: Text(
                      '+9647816913486',
                      style: TextStyle(
                        fontSize: 14,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    primaryColor: primaryColor,
                    onTap: () {
                      _launchUrl('tel:+9647816913486');
                      Navigator.of(context).pop(); // Close dialog after action
                    },
                  ),

                  SizedBox(height: 16),
                  Divider(color: primaryColor.withOpacity(0.1)),
                  SizedBox(height: 16),

                  // Website
                  _buildDialogContactItem(
                    icon: Icons.language,
                    title: Locales.string(context, 'website'),
                    content: Text(
                      Locales.string(context, 'visit_our_website'),
                      style: TextStyle(
                        fontSize: 14,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    primaryColor: primaryColor,
                    onTap: () {
                      _launchUrl('https://mymedicines.net');
                      Navigator.of(context).pop(); // Close dialog after action
                    },
                  ),
                  _buildDialogContactItem(
                    icon: Icons.language,
                    title: Locales.string(context, 'data_source'),
                    content: Text(
                      Locales.string(context, 'visit_our_website'),
                      style: TextStyle(
                        fontSize: 14,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    primaryColor: primaryColor,
                    onTap: () {
                      _launchUrl('https://www.drugs.com/');
                      Navigator.of(context).pop(); // Close dialog after action
                    },
                  ),

                  SizedBox(height: 24),

                  // Close button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: LocaleText(
                      'close',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Drug',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to build contact items in the dialog
  Widget _buildDialogContactItem({
    required IconData icon,
    required String title,
    required Widget content,
    required Color primaryColor,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  content,
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_forward_ios, color: primaryColor, size: 14),
          ],
        ),
      ),
    );
  }

  // Section title with icon
  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    IconData icon,
    Color primaryColor,
    Color textColor,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return Row(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white : primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        SizedBox(width: 12),
        LocaleText(
          title,
          style: TextStyle(
            fontFamily: 'Drug',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  // Modern language selector
  Widget _buildLanguageSelector(
    BuildContext context,
    SettingsProvider settingsProvider, {
    required Color surfaceColor,
    required Color primaryColor,
    required Color accentColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Language options in a more modern grid layout
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              // English
              _buildLanguageOption(
                context: context,
                label: 'English',
                isSelected: settingsProvider.language == 'en',
                onTap: () {
                  settingsProvider.setLanguage('en');
                  Locales.change(context, 'en');
                },
                primaryColor: primaryColor,
                accentColor: accentColor,
                surfaceColor: surfaceColor,
              ),
              // Arabic
              _buildLanguageOption(
                context: context,
                label: 'عربي',
                isSelected: settingsProvider.language == 'ar',
                onTap: () {
                  settingsProvider.setLanguage('ar');
                  Locales.change(context, 'ar');
                },
                primaryColor: primaryColor,
                accentColor: accentColor,
                surfaceColor: surfaceColor,
              ),
              // Kurdish
              _buildLanguageOption(
                context: context,
                label: 'کوردی',
                isSelected: settingsProvider.language == 'fa',
                onTap: () {
                  settingsProvider.setLanguage('fa');
                  Locales.change(context, 'fa');
                },
                primaryColor: primaryColor,
                accentColor: accentColor,
                surfaceColor: surfaceColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Modern language option button
  Widget _buildLanguageOption({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
    required Color accentColor,
    required Color surfaceColor,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? accentColor
                    : isDarkMode
                    ? const Color.fromARGB(255, 119, 118, 118)
                    : Colors.black,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Drug',
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
            color:
                isSelected
                    ? Colors.white
                    : isDarkMode
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),
    );
  }

  // Modern text size selector
  Widget _buildTextSizeSelector(
    BuildContext context,
    SettingsProvider settingsProvider, {
    required Color surfaceColor,
    required Color primaryColor,
    required Color accentColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Aa',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Drug',
                  fontWeight: FontWeight.w400,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: accentColor,
                    inactiveTrackColor: primaryColor.withOpacity(0.1),
                    thumbColor: primaryColor,
                    trackHeight: 4,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayColor: primaryColor.withOpacity(0.1),
                    valueIndicatorColor: primaryColor,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  child: Slider(
                    value: settingsProvider.textSize,
                    min: 0.8,
                    max: 1.2,
                    divisions: 4,
                    label: (settingsProvider.textSize).toStringAsFixed(1),
                    onChanged: (value) {
                      settingsProvider.setTextSize(value);
                    },
                  ),
                ),
              ),
              Text(
                'Aa',
                style: TextStyle(
                  fontFamily: 'Drug',
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LocaleText(
                    'current_scale',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    "${settingsProvider.textSize.toStringAsFixed(1)}x",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modern theme mode selector
  Widget _buildThemeModeSelector(
    BuildContext context,
    ThemeProvider themeProvider, {
    required Color surfaceColor,
    required Color primaryColor,
    required Color accentColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Light theme
              _buildThemeOption(
                context: context,
                label: 'light',
                icon: Icons.wb_sunny_rounded,
                isSelected: themeProvider.themeMode == AppThemeMode.light,
                onTap: () => themeProvider.setThemeMode(AppThemeMode.light),
                primaryColor: primaryColor,
                accentColor: accentColor,
                surfaceColor: surfaceColor,
              ),
              // Dark theme
              _buildThemeOption(
                context: context,
                label: 'dark',
                icon: Icons.nights_stay_rounded,
                isSelected: themeProvider.themeMode == AppThemeMode.dark,
                onTap: () => themeProvider.setThemeMode(AppThemeMode.dark),
                primaryColor: primaryColor,
                accentColor: accentColor,
                surfaceColor: surfaceColor,
              ),
              // System theme
              _buildThemeOption(
                context: context,
                label: 'auto',
                icon: Icons.brightness_auto,
                isSelected: themeProvider.themeMode == AppThemeMode.system,
                onTap: () => themeProvider.setThemeMode(AppThemeMode.system),
                primaryColor: primaryColor,
                accentColor: accentColor,
                surfaceColor: surfaceColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Modern theme option button
  Widget _buildThemeOption({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
    required Color accentColor,
    required Color surfaceColor,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: 70,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isSelected ? accentColor : primaryColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color:
                      isSelected
                          ? Colors.white
                          : isDarkMode
                          ? Colors.white
                          : Colors.black,
                  size: 28,
                ),
              ),
            ),
            SizedBox(height: 8),
            LocaleText(
              label,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Drug',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                color:
                    isSelected
                        ? primaryColor
                        : isDarkMode
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern footer
  Widget _buildFooter(
    BuildContext context, {
    required Color primaryColor,
    required Color accentColor,
    required Color subtitleColor,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap:
                () => _showDevelopersDialog(
                  context,
                  primaryColor,
                  accentColor,
                  subtitleColor,
                ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 8),
                  LocaleText(
                    'developed_by',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontFamily: 'Drug',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Show developers information dialog
  void _showDevelopersDialog(
    BuildContext context,
    Color primaryColor,
    Color accentColor,
    Color subtitleColor,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with app logo
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.1),
                  ),
                  child: Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.people_alt_rounded,
                            size: 30,
                            color: primaryColor,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Title
                LocaleText(
                  'our_development_team',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? primaryColor
                            : Colors.white,
                    fontFamily: 'Drug',
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8),

                // Divider with accent color
                Divider(color: accentColor, thickness: 0.8),
                SizedBox(height: 16),

                // Developer information
                _buildDeveloperInfo(
                  context,
                  Locales.string(context, 'muhammed_salar'),
                  Locales.string(context, 'lead_developer'),
                  primaryColor,
                  subtitleColor,
                ),
                SizedBox(height: 12),
                _buildDeveloperInfo(
                  context,
                  Locales.string(context, 'muhammed_abubakr'),
                  Locales.string(context, 'ui_ux_designer'),
                  primaryColor,
                  subtitleColor,
                ),
                SizedBox(height: 12),
                _buildDeveloperInfo(
                  context,
                  Locales.string(context, 'balen_muhammed'),
                  Locales.string(context, 'backend_developer'),
                  primaryColor,
                  subtitleColor,
                ),
                SizedBox(height: 12),
                _buildDeveloperInfo(
                  context,
                  Locales.string(context, 'karmand_jasm'),
                  Locales.string(context, 'cross_platform_developer'),
                  primaryColor,
                  subtitleColor,
                ),

                SizedBox(height: 24),

                // Version information
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LocaleText(
                        'MyMedicines',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Drug',
                          color: accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ': v${AppConstants.appVersion}',
                        style: TextStyle(fontSize: 12, color: accentColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Close button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: LocaleText(
                    'close',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Drug',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build each developer's info
  Widget _buildDeveloperInfo(
    BuildContext context,
    String name,
    String role,
    Color primaryColor,
    Color subtitleColor,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return Row(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor.withOpacity(0.1),
          ),
          child: Icon(
            Icons.person,
            size: 20,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  fontFamily: 'Drug',
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  fontSize: 12,
                  color: subtitleColor,
                  fontFamily: 'Drug',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Feedback button
  Widget _buildFeedbackButton(
    BuildContext context, {
    required Color surfaceColor,
    required Color primaryColor,
    required Color accentColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeedbackScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDarkMode ? Colors.white : Colors.black),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.feedback,
              size: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            SizedBox(width: 8),
            LocaleText(
              'send_feedback',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontFamily: 'Drug',
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
