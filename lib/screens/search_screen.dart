// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/theme_provider.dart';
import '../providers/medicine_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/medicine_card.dart';
import '../colors/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(_searchController.text);
    });
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      setState(() {
        _isSearching = true;
      });

      // Trigger search in provider
      Provider.of<MedicineProvider>(
        context,
        listen: false,
      ).searchMedicines(query).then((_) {
        setState(() {
          _isSearching = false;
        });
      });
    } else {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        title: LocaleText(
          'search',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Drug"),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: Locales.string(context, 'search_medicines'),
                hintStyle: TextStyle(fontFamily: 'Drug'),
                prefixIcon: Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade100,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _performSearch,
            ),
          ),

          // Search results
          Expanded(
            child:
                _isSearching
                    ? Center(child: CircularProgressIndicator())
                    : medicineProvider.error.isNotEmpty
                    ? Center(
                      child: Text(
                        medicineProvider.error,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : medicineProvider.searchResults.isEmpty
                    ? Center(
                      child: LocaleText(
                        _searchController.text.isEmpty
                            ? 'search_instructions'
                            : 'no_results_found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Drug',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: medicineProvider.searchResults.length,
                      itemBuilder: (context, index) {
                        final medicine = medicineProvider.searchResults[index];
                        return MedicineCard(
                          medicine: medicine,
                          isFavorite: favoriteProvider.isFavorite(medicine.id),
                          onToggleFavorite: () {
                            favoriteProvider.toggleFavorite(medicine);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
