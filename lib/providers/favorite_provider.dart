// lib/providers/favorite_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/medicine.dart';

class FavoriteProvider with ChangeNotifier {
  List<Medicine> _favoriteMedicines = [];
  bool _isLoading = false;
  String _error = '';
  static const String _favoritesKey = 'favorite_medicines';

  List<Medicine> get favoriteMedicines => _favoriteMedicines;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Constructor to load favorites when provider is created
  FavoriteProvider() {
    _loadInitialFavorites();
  }

  // Load initial favorites
  Future<void> _loadInitialFavorites() async {
    try {
      await loadFavorites();
    } catch (e) {
      _error = 'Failed to load initial favorites: $e';
      notifyListeners();
    }
  }

  // Load favorites from shared preferences
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson != null) {
        final List<dynamic> decodedList = json.decode(favoritesJson);
        _favoriteMedicines =
            decodedList.map((item) => Medicine.fromJson(item)).toList();
      } else {
        _favoriteMedicines = [];
      }
    } catch (e) {
      _error = 'Failed to load favorites: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save favorites to shared preferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedList = json.encode(
        _favoriteMedicines.map((medicine) => medicine.toJson()).toList(),
      );
      await prefs.setString(_favoritesKey, encodedList);
    } catch (e) {
      _error = 'Failed to save favorites: $e';
      notifyListeners();
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Medicine medicine) async {
    try {
      final updatedMedicine = medicine.copyWith(
        isFavorite: !medicine.isFavorite,
      );

      if (updatedMedicine.isFavorite) {
        // Add to favorites if not already present
        if (!_favoriteMedicines.any((med) => med.id == medicine.id)) {
          _favoriteMedicines.add(updatedMedicine);
        }
      } else {
        // Remove from favorites
        _favoriteMedicines.removeWhere((med) => med.id == medicine.id);
      }

      await _saveFavorites();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update favorite status: $e';
      notifyListeners();
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(int medicineId) async {
    try {
      final index = _favoriteMedicines.indexWhere(
        (med) => med.id == medicineId,
      );
      if (index != -1) {
        _favoriteMedicines.removeAt(index);
        await _saveFavorites();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to remove from favorites: $e';
      notifyListeners();
    }
  }

  // Check if a medicine is favorite
  bool isFavorite(int medicineId) {
    return _favoriteMedicines.any((med) => med.id == medicineId);
  }

  // Reset error
  void resetError() {
    _error = '';
    notifyListeners();
  }
}
