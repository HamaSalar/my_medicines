//lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/theme_provider.dart';
import '../providers/medicine_provider.dart';
import '../services/connectivity_service.dart';
import '../colors/colors.dart';
import 'medicine_list_screen.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _currentCarouselIndex = 0;
  final List<String> _carouselImages = [
    'assets/images/image5.jpg',
    'assets/images/images1.jpg',
    'assets/images/images2.jpg',
    'assets/images/images3.jpg',
  ];
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    // Ensure medicine types are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicineProvider>(
        context,
        listen: false,
      ).initializeData(context);
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityService = ConnectivityService();
    final isConnected = await connectivityService.isConnected();
    setState(() {
      _isOnline = isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final medicineProvider = Provider.of<MedicineProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Icon(
              FontAwesomeIcons.pills,
              size: 18,
              color: AppColors.accentColor,
            ),
            SizedBox(width: 8),
            LocaleText(
              'mymedicines',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                fontFamily: 'Drug',
                color: isDarkMode ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey<bool>(themeProvider.isDarkMode),
                color: AppColors.accentColor,
              ),
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
          SizedBox(width: 8),
        ],
      ),
      body:
          medicineProvider.isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.accentColor,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(height: 16),
                    LocaleText(
                      'loadingmedicines',
                      style: TextStyle(
                        fontFamily: 'Drug',
                        color:
                            isDarkMode
                                ? Colors.white70
                                : AppColors.textDark.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
              : medicineProvider.error.isNotEmpty
              ? Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkPrimary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.errorColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          color: AppColors.errorColor,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 24),
                      LocaleText(
                        'unabletoloadmedicines',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Drug',
                          color: isDarkMode ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        medicineProvider.error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Drug',
                          color:
                              isDarkMode
                                  ? Colors.white70
                                  : AppColors.textDark.withOpacity(0.7),
                        ),
                      ),

                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          medicineProvider.resetError();
                          medicineProvider.initializeData(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor,
                          foregroundColor: Colors.white,
                          minimumSize: Size(180, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: LocaleText(
                          'tryagain',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Drug',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : RefreshIndicator(
                color: AppColors.accentColor,
                backgroundColor:
                    isDarkMode ? AppColors.darkPrimary : Colors.white,
                onRefresh: () async {
                  await _checkConnectivity();
                  return medicineProvider.initializeData(context);
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 180,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.easeInOut,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: Duration(
                            milliseconds: 800,
                          ),
                          viewportFraction: 0.85,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentCarouselIndex = index;
                            });
                          },
                        ),
                        items:
                            _carouselImages.map((imagePath) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0, 4),
                                          blurRadius: 8.0,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            color:
                                                isDarkMode
                                                    ? AppColors.darkPrimary
                                                    : Colors.grey.shade200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image_not_supported,
                                                  size: 40,
                                                  color:
                                                      isDarkMode
                                                          ? Colors.white54
                                                          : Colors
                                                              .grey
                                                              .shade500,
                                                ),
                                                SizedBox(height: 8),
                                                LocaleText(
                                                  "imagenotavailable",
                                                  style: TextStyle(
                                                    fontFamily: 'Drug',
                                                    color:
                                                        isDarkMode
                                                            ? Colors.white54
                                                            : Colors
                                                                .grey
                                                                .shade500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 16),
                      // Carousel indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            _carouselImages.asMap().entries.map((entry) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width:
                                    _currentCarouselIndex == entry.key
                                        ? 18.0
                                        : 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      _currentCarouselIndex == entry.key
                                          ? AppColors.accentColor
                                          : isDarkMode
                                          ? Colors.white30
                                          : Colors.grey.shade300,
                                ),
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 32),
                      // Medicine Types Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LocaleText(
                              'medicinetypes',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Drug',
                                color:
                                    isDarkMode
                                        ? Colors.white
                                        : AppColors.textDark,
                              ),
                            ),
                            if (!_isOnline)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.errorColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.wifi_off,
                                      size: 14,
                                      color: AppColors.errorColor,
                                    ),
                                    SizedBox(width: 4),
                                    LocaleText(
                                      'offlinemode',
                                      style: TextStyle(
                                        fontFamily: 'Drug',
                                        color: AppColors.errorColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Medicine Type Cards - Modern Card Design
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child:
                            medicineProvider.medicineTypes.isEmpty
                                ? Container(
                                  padding: EdgeInsets.all(32),
                                  margin: EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(
                                    color:
                                        isDarkMode
                                            ? AppColors.darkPrimary.withOpacity(
                                              0.5,
                                            )
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          isDarkMode
                                              ? Colors.white10
                                              : Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.medication_outlined,
                                        size: 48,
                                        color:
                                            isDarkMode
                                                ? Colors.white30
                                                : Colors.grey.shade400,
                                      ),
                                      SizedBox(height: 16),
                                      LocaleText(
                                        'no_medicine_types',

                                        style: TextStyle(
                                          fontFamily: 'Drug',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              isDarkMode
                                                  ? Colors.white54
                                                  : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 0.75,
                                      ),
                                  itemCount:
                                      medicineProvider.medicineTypes.length,
                                  itemBuilder: (context, index) {
                                    final type =
                                        medicineProvider.medicineTypes[index];

                                    // Modern color palette
                                    final List<Color> cardColors = [
                                      Color(0xFFB8860B), // Gold
                                      Color(0xFF00BFA5), // Teal
                                      Color(0xFFFF6B6B), // Coral
                                      Color(0xFF43A047), // green
                                      Color(0xFFFF9F43), // Orange
                                      // Sky Blue
                                    ];

                                    final Color cardColor =
                                        cardColors[index % cardColors.length];

                                    // Modern icons
                                    final List<IconData> medicineIcons = [
                                      FontAwesomeIcons.capsules,
                                      FontAwesomeIcons.syringe,
                                      FontAwesomeIcons.prescriptionBottle,
                                      Icons.local_pharmacy_outlined,
                                      Icons.health_and_safety_outlined,
                                    ];

                                    final IconData cardIcon =
                                        medicineIcons[index %
                                            medicineIcons.length];

                                    return Hero(
                                      tag: 'medicine_type_${type.id}',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            if (!_isOnline &&
                                                !type.isDownloaded) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: LocaleText(
                                                    'this_medicine_type_is_not_available_offline_please_connect_to_the_internet_to_download_it',
                                                  ),
                                                  backgroundColor:
                                                      AppColors.errorColor,
                                                ),
                                              );
                                              return;
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        MedicineListScreen(
                                                          typeId: type.id,
                                                          typeName: type.name,
                                                        ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  cardColor.withOpacity(0.8),
                                                  cardColor,
                                                ],
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: cardColor.withOpacity(
                                                    0.3,
                                                  ),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              children: [
                                                // Background pattern
                                                Positioned(
                                                  right: -15,
                                                  bottom: -15,
                                                  child: Icon(
                                                    cardIcon,
                                                    size: 80,
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                  ),
                                                ),
                                                // Content
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Icon
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                          8,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: Icon(
                                                          cardIcon,
                                                          size: 30,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      // Title
                                                      Text(
                                                        type.name,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Drug',
                                                        ),
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                      SizedBox(height: 6),
                                                      // Status indicator
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              _isOnline &&
                                                                      !type
                                                                          .isDownloaded
                                                                  ? Icons
                                                                      .cloud_download_outlined
                                                                  : type
                                                                      .isDownloaded
                                                                  ? Icons
                                                                      .check_circle_outline
                                                                  : Icons
                                                                      .cloud_off_outlined,
                                                              size: 14,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(width: 4),
                                                            LocaleText(
                                                              _isOnline &&
                                                                      !type
                                                                          .isDownloaded
                                                                  ? 'download'
                                                                  : type
                                                                      .isDownloaded
                                                                  ? 'available'
                                                                  : 'offline',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
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
                                    );
                                  },
                                ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
    );
  }
}
