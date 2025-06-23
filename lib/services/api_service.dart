// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_locales/flutter_locales.dart';
import '../models/medicine.dart';
import '../models/medicine_type.dart';
import '../models/feedback.dart';
// import '../models/app_feedback.dart';

class AppConstants {
  // API Base URL - Replace with your Hostinger server URL
  static const String apiBaseUrl = 'https://mymedicines.net/php_mydrug';

  static const String appVersion = '1.0.0';

  // Static medicine types data - simplified version
  static List<Map<String, dynamic>> getMedicineTypes(BuildContext context) => [
    {
      "id": 1,
      "name": Locales.string(context, 'medicine_type_pills'),
      "image": "",
    },
    {
      "id": 2,
      "name": Locales.string(context, 'medicine_type_injections'),
      "image": "",
    },
    {
      "id": 3,
      "name": Locales.string(context, 'medicine_type_capsules'),
      "image": "",
    },
    {
      "id": 4,
      "name": Locales.string(context, 'medicine_type_creams'),
      "image": "",
    },
    {
      "id": 5,
      "name": Locales.string(context, 'medicine_type_syrups'),
      "image": "",
    },
  ];
}

class ApiService {
  // Base URL - Replace with your Hostinger server URL
  final String baseUrl = AppConstants.apiBaseUrl;

  // Get all medicine types
  Future<List<MedicineType>> getMedicineTypes(BuildContext context) async {
    // Simply return the static data without try-catch since it can't fail
    return AppConstants.getMedicineTypes(context)
        .map(
          (json) => MedicineType(
            id: json['id'],
            name: json['name'],
            image: json['image'],
            isDownloaded: true,
          ),
        )
        .toList();
  }

  // Get medicines by type
  Future<List<Medicine>> getMedicinesByType(int typeId) async {
    try {
      final url = Uri.parse(
        '$baseUrl/get_medicines_by_type.php?type_id=$typeId',
      );
      // print('Fetching medicines by type from: $url');

      final response = await http.get(url);
      // print('Response status code: ${response.statusCode}');
      // print('Response headers: ${response.headers}');
      // print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Empty response received from server');
        }

        String responseBody = response.body.trim();
        // Try to clean the response if it contains any BOM or invalid characters
        if (responseBody.startsWith(RegExp(r'[^\[\{]'))) {
          responseBody = responseBody.substring(
            responseBody.indexOf(RegExp(r'[\[\{]')),
          );
        }

        try {
          final List<dynamic> data = json.decode(responseBody);
          // print('Parsed JSON data: $data');
          return data.map((json) => Medicine.fromJson(json)).toList();
        } on FormatException catch (e) {
          print('JSON parse error: $e');
          // print('Attempted to parse: $responseBody');

          // Try to decode if it might be Base64 encoded
          try {
            final decoded = utf8.decode(base64.decode(responseBody));
            // print('Decoded from Base64: $decoded');
            final List<dynamic> data = json.decode(decoded);
            return data.map((json) => Medicine.fromJson(json)).toList();
          } catch (base64Error) {
            // print('Base64 decode attempt failed: $base64Error');
            throw Exception(
              'Invalid response format: Unable to parse response as JSON or Base64',
            );
          }
        }
      } else {
        throw Exception('Failed to load medicines: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching medicines: $e');
    }
  }

  // Search medicines
  Future<List<Medicine>> searchMedicines(String query) async {
    try {
      final url = Uri.parse('$baseUrl/get_medicines.php?search=$query');
      print('Searching medicines from: $url');

      final response = await http.get(url);
      // print('Response status code: ${response.statusCode}');
      // print('Response headers: ${response.headers}');
      // print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Empty response received from server');
        }

        String responseBody = response.body.trim();
        // Try to clean the response if it contains any BOM or invalid characters
        if (responseBody.startsWith(RegExp(r'[^\[\{]'))) {
          responseBody = responseBody.substring(
            responseBody.indexOf(RegExp(r'[\[\{]')),
          );
        }

        try {
          final List<dynamic> data = json.decode(responseBody);
          // print('Parsed JSON data: $data');
          return data.map((json) => Medicine.fromJson(json)).toList();
        } on FormatException catch (e) {
          print('JSON parse error: $e');
          // print('Attempted to parse: $responseBody');

          // Try to decode if it might be Base64 encoded
          try {
            final decoded = utf8.decode(base64.decode(responseBody));
            // print('Decoded from Base64: $decoded');
            final List<dynamic> data = json.decode(decoded);
            return data.map((json) => Medicine.fromJson(json)).toList();
          } catch (base64Error) {
            // print('Base64 decode attempt failed: $base64Error');
            throw Exception(
              'Invalid response format: Unable to parse response as JSON or Base64',
            );
          }
        }
      } else {
        throw Exception('Failed to search medicines: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching medicines: $e');
    }
  }

  // Send feedback
  Future<void> sendFeedback(AppFeedback feedback) async {
    try {
      final url = Uri.parse('$baseUrl/submit_feedback.php');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(feedback.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send feedback: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending feedback: $e');
    }
  }
}
