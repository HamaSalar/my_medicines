// lib/screens/medicine_list_screen.dart
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/medicine_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/medicine_card.dart';
import '../services/connectivity_service.dart';
import '../colors/colors.dart';
import '../providers/theme_provider.dart';

class MedicineListScreen extends StatefulWidget {
  final int typeId;
  final String typeName;

  const MedicineListScreen({
    super.key,
    required this.typeId,
    required this.typeName,
  });

  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isDownloading = false;
  bool _isOnline = true;
  bool _showSearch = false;
  bool _showSafetyCards = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  Future<void> _loadData() async {
    // Check connectivity
    _isOnline = await _connectivityService.isConnected();

    // Load medicines
    await Provider.of<MedicineProvider>(
      context,
      listen: false,
    ).loadMedicinesByType(context, widget.typeId);

    // Make sure favorites are loaded
    await Provider.of<FavoriteProvider>(context, listen: false).loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool isDarkMode = themeProvider.isDarkMode;
    // Filter medicines based on search query
    final filteredMedicines =
        _searchQuery.isEmpty
            ? medicineProvider.medicines
            : medicineProvider.medicines.where((medicine) {
              return medicine.name.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  (medicine.description.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ));
            }).toList();

    final List<Widget> safetyMessages = [
      _buildSafetyCard(
        context,
        'Never take expired medications',
        Icons.warning,
        Colors.red,
      ),
      _buildSafetyCard(
        context,
        'Taking medicines at wrong times can be dangerous',
        Icons.warning,
        Colors.red,
      ),
      _buildSafetyCard(
        context,
        'Do not mix medications without doctor approval',
        Icons.warning,
        Colors.red,
      ),
      _buildSafetyCard(
        context,
        'Always consult your doctor before taking any medication',
        Icons.warning,
        Colors.red,
      ),
      _buildSafetyCard(
        context,
        'Follow prescribed dosage and instructions carefully',
        Icons.warning,
        Colors.red,
      ),
    ];

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color:
                                  isDarkMode
                                      ? AppColors.lightBackground
                                      : AppColors.darkBackground,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            widget.typeName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color:
                                  isDarkMode
                                      ? AppColors.lightBackground
                                      : AppColors.darkBackground,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _showSafetyCards
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color:
                                  isDarkMode
                                      ? AppColors.lightBackground
                                      : AppColors.darkBackground,
                            ),
                            onPressed: () {
                              setState(() {
                                _showSafetyCards = !_showSafetyCards;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              _showSearch ? Icons.close : Icons.search,
                              color:
                                  isDarkMode
                                      ? AppColors.lightBackground
                                      : AppColors.darkBackground,
                            ),
                            onPressed: () {
                              setState(() {
                                _showSearch = !_showSearch;
                                if (!_showSearch) {
                                  _searchController.clear();
                                }
                              });
                            },
                          ),
                          if (_isOnline)
                            Consumer<MedicineProvider>(
                              builder: (context, medicineProvider, child) {
                                final medicineType = medicineProvider
                                    .medicineTypes
                                    .firstWhere(
                                      (type) => type.id == widget.typeId,
                                      orElse:
                                          () =>
                                              throw Exception(
                                                'Medicine type not found',
                                              ),
                                    );

                                return IconButton(
                                  icon:
                                      _isDownloading
                                          ? SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color:
                                                  isDarkMode
                                                      ? AppColors
                                                          .lightBackground
                                                      : AppColors
                                                          .darkBackground,
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : Icon(
                                            medicineType.isDownloaded
                                                ? Icons.delete_outline
                                                : Icons.download_outlined,
                                            color:
                                                isDarkMode
                                                    ? AppColors.lightBackground
                                                    : AppColors.darkBackground,
                                          ),
                                  onPressed:
                                      _isDownloading
                                          ? null
                                          : () async {
                                            setState(() {
                                              _isDownloading = true;
                                            });

                                            try {
                                              if (medicineType.isDownloaded) {
                                                await medicineProvider
                                                    .removeMedicineType(
                                                      widget.typeId,
                                                    );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: LocaleText(
                                                      'removed_offline_data',
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                await medicineProvider
                                                    .downloadMedicineType(
                                                      widget.typeId,
                                                    );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: LocaleText(
                                                      'downloaded_for_offline',
                                                    ),
                                                  ),
                                                );
                                              }
                                            } finally {
                                              setState(() {
                                                _isDownloading = false;
                                              });
                                            }
                                          },
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (_showSearch)
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? AppColors.darkBackground
                                  : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search medicines...',
                            prefixIcon: Icon(
                              Icons.search,
                              color:
                                  isDarkMode
                                      ? AppColors.lightBackground
                                      : AppColors.darkBackground,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Medicine List with Safety Cards
            Expanded(
              child:
                  medicineProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : medicineProvider.error.isNotEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              medicineProvider.error,
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                medicineProvider.resetError();
                                _loadData();
                              },
                              child: LocaleText('retry'),
                            ),
                          ],
                        ),
                      )
                      : filteredMedicines.isEmpty
                      ? Center(
                        child:
                            _searchQuery.isNotEmpty
                                ? Text(
                                  'No medicines found for "$_searchQuery"',
                                  style: TextStyle(fontSize: 16),
                                )
                                : LocaleText(
                                  'no_medicines_found',
                                  style: TextStyle(fontSize: 16),
                                ),
                      )
                      : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView(
                          padding: EdgeInsets.all(16),
                          children: [
                            // Safety Cards (conditionally shown)
                            if (_showSafetyCards)
                              Container(
                                height: 100,
                                margin: EdgeInsets.only(bottom: 16),
                                child: CarouselSlider(
                                  items: safetyMessages,
                                  options: CarouselOptions(
                                    height: 100,
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 5),
                                    autoPlayAnimationDuration: Duration(
                                      milliseconds: 800,
                                    ),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.9,
                                  ),
                                ),
                              ),
                            // Medicine List
                            ...filteredMedicines
                                .map(
                                  (medicine) => MedicineCard(
                                    medicine: medicine,
                                    isFavorite: favoriteProvider.isFavorite(
                                      medicine.id,
                                    ),
                                    onToggleFavorite: () {
                                      favoriteProvider.toggleFavorite(medicine);
                                    },
                                  ),
                                )
                                ,
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyCard(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
