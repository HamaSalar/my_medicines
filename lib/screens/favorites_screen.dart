// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

import '../providers/favorite_provider.dart';
import '../widgets/medicine_card.dart';
import '../colors/colors.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorites when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoriteProvider>(context, listen: false).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        title: LocaleText(
          'favorites',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Drug'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => favoriteProvider.loadFavorites(),
        child:
            favoriteProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : favoriteProvider.error.isNotEmpty
                ? Center(
                  child: Text(
                    favoriteProvider.error,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
                : favoriteProvider.favoriteMedicines.isEmpty
                ? Center(
                  child: LocaleText(
                    'no_favorites',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                )
                : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: favoriteProvider.favoriteMedicines.length,
                  itemBuilder: (context, index) {
                    final medicine = favoriteProvider.favoriteMedicines[index];
                    return Dismissible(
                      key: Key('favorite_${medicine.id}'),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: LocaleText('confirm'),
                              content: Text(
                                Text(
                                  'remove_from_favorites_confirm',
                                ).toString(),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: Text(Text('cancel').toString()),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: Text(
                                    Text('remove').toString(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        favoriteProvider.removeFromFavorites(medicine.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('removed_from_favorites'),
                            action: SnackBarAction(
                              label: 'undo',
                              onPressed: () {
                                favoriteProvider.toggleFavorite(medicine);
                              },
                            ),
                          ),
                        );
                      },
                      child: MedicineCard(
                        medicine: medicine,
                        isFavorite: true,
                        onToggleFavorite: () {
                          favoriteProvider.toggleFavorite(medicine);
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
