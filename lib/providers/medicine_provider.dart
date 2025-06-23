// lib/providers/medicine_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/medicine.dart';
import '../models/medicine_type.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import '../services/connectivity_service.dart';
import '../providers/favorite_provider.dart';

class MedicineProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ConnectivityService _connectivityService = ConnectivityService();

  List<MedicineType> _medicineTypes = [];
  List<Medicine> _medicines = [];
  List<Medicine> _searchResults = [];
  bool _isLoading = false;
  String _error = '';

  List<MedicineType> get medicineTypes => _medicineTypes;
  List<Medicine> get medicines => _medicines;
  List<Medicine> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Initialize and fetch medicine types
  Future<void> initializeData(BuildContext context) async {
    _setLoading(true);

    try {
      // Check if we have internet connection
      bool isConnected = await _connectivityService.isConnected();

      if (isConnected) {
        // Fetch medicine types from server
        await _fetchMedicineTypesFromServer(context);
      } else {
        // Get locally stored medicine types
        await _loadMedicineTypesFromLocal();
      }
    } catch (e) {
      _setError('Failed to initialize data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch medicine types from server
  Future<void> _fetchMedicineTypesFromServer(BuildContext context) async {
    try {
      final types = await _apiService.getMedicineTypes(context);
      _medicineTypes = types;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch medicine types: $e');
      // Fallback to local database
      await _loadMedicineTypesFromLocal();
    }
  }

  // Load medicine types from local database
  Future<void> _loadMedicineTypesFromLocal() async {
    try {
      final types = await _dbHelper.getMedicineTypes();
      _medicineTypes = types;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load medicine types from local database: $e');
    }
  }

  // Load medicines by type
  Future<void> loadMedicinesByType(BuildContext context, int typeId) async {
    _setLoading(true);
    try {
      bool isConnected = await _connectivityService.isConnected();

      if (isConnected) {
        // Fetch medicines directly from server
        _medicines = await _apiService.getMedicinesByType(typeId);
      } else {
        // Try to get from local database if available
        _medicines = await _dbHelper.getMedicinesByType(typeId);
        if (_medicines.isEmpty) {
          _setError('No internet connection and no local data available');
          return;
        }
      }

      // Sync favorite status with FavoriteProvider
      final favoriteProvider = Provider.of<FavoriteProvider>(
        context,
        listen: false,
      );
      for (var medicine in _medicines) {
        medicine.isFavorite = favoriteProvider.isFavorite(medicine.id);
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load medicines: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Download medicines by type (optional feature)
  Future<void> downloadMedicineType(int typeId) async {
    _setLoading(true);

    try {
      bool isConnected = await _connectivityService.isConnected();

      if (!isConnected) {
        _setError('No internet connection. Cannot download medicines.');
        return;
      }

      // Fetch medicines from server
      final meds = await _apiService.getMedicinesByType(typeId);

      // Save to local database
      for (var med in meds) {
        await _dbHelper.insertMedicine(med);
      }

      // Mark type as downloaded
      await _dbHelper.updateMedicineTypeDownloadStatus(typeId, true);

      // Update medicine types list
      final index = _medicineTypes.indexWhere((type) => type.id == typeId);
      if (index != -1) {
        _medicineTypes[index] = _medicineTypes[index].copyWith(
          isDownloaded: true,
        );
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to download medicines: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Remove downloaded medicines by type
  Future<void> removeMedicineType(int typeId) async {
    _setLoading(true);

    try {
      // Clear medicines of this type
      await _dbHelper.clearMedicinesByType(typeId);

      // Mark type as not downloaded
      await _dbHelper.updateMedicineTypeDownloadStatus(typeId, false);

      // Update medicine types list
      final index = _medicineTypes.indexWhere((type) => type.id == typeId);
      if (index != -1) {
        _medicineTypes[index] = _medicineTypes[index].copyWith(
          isDownloaded: false,
        );
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to remove downloaded medicines: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search medicines
  Future<void> searchMedicines(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _setLoading(true);

    try {
      bool isConnected = await _connectivityService.isConnected();

      if (isConnected) {
        // Search on server
        _searchResults = await _apiService.searchMedicines(query);
      } else {
        // Search locally
        _searchResults = await _dbHelper.searchMedicines(query);
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to search medicines: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _error = '';
    }
    notifyListeners();
  }

  void _setError(String errorMsg) {
    _error = errorMsg;
    notifyListeners();
  }

  // Reset error
  void resetError() {
    _error = '';
    notifyListeners();
  }
}
