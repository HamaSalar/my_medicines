// lib/models/medicine.dart
class Medicine {
  final int id;
  final String name;
  final String otherNames;
  final String description; // English description
  final String description1; // Kurdish description
  final String description2; // Arabic description
  final String uses; // English uses
  final String uses1; // Kurdish uses
  final String uses2; // Arabic uses
  final String dosage; // English dosage
  final String dosage1; // Kurdish dosage
  final String dosage2; // Arabic dosage
  final int typeId;
  final String typeName;
  bool isFavorite;

  Medicine({
    required this.id,
    required this.name,
    required this.otherNames,
    required this.description,
    required this.description1,
    required this.description2,
    required this.uses,
    required this.uses1,
    required this.uses2,
    required this.dosage,
    required this.dosage1,
    required this.dosage2,
    required this.typeId,
    required this.typeName,
    this.isFavorite = false,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      otherNames: json['other_names'] ?? '',
      description: json['description'] ?? '',
      description1: json['description1'] ?? '',
      description2: json['description2'] ?? '',
      uses: json['uses'] ?? '',
      uses1: json['uses1'] ?? '',
      uses2: json['uses2'] ?? '',
      dosage: json['dosage'] ?? '',
      dosage1: json['dosage1'] ?? '',
      dosage2: json['dosage2'] ?? '',
      typeId: json['type_id'],
      typeName: json['type_name'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'other_names': otherNames,
      'description': description,
      'description1': description1,
      'description2': description2,
      'uses': uses,
      'uses1': uses1,
      'uses2': uses2,
      'dosage': dosage,
      'dosage1': dosage1,
      'dosage2': dosage2,
      'type_id': typeId,
      'type_name': typeName,
      'isFavorite': isFavorite,
    };
  }

  Medicine copyWith({
    int? id,
    String? name,
    String? otherNames,
    String? description,
    String? description1,
    String? description2,
    String? uses,
    String? uses1,
    String? uses2,
    String? dosage,
    String? dosage1,
    String? dosage2,
    int? typeId,
    String? typeName,
    bool? isFavorite,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      otherNames: otherNames ?? this.otherNames,
      description: description ?? this.description,
      description1: description1 ?? this.description1,
      description2: description2 ?? this.description2,
      uses: uses ?? this.uses,
      uses1: uses1 ?? this.uses1,
      uses2: uses2 ?? this.uses2,
      dosage: dosage ?? this.dosage,
      dosage1: dosage1 ?? this.dosage1,
      dosage2: dosage2 ?? this.dosage2,
      typeId: typeId ?? this.typeId,
      typeName: typeName ?? this.typeName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Helper method to get description based on language
  String getDescriptionForLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'ar':
        return description2;
      case 'fa':
        return description1;
      case 'en':
      default:
        return description;
    }
  }

  // Helper method to get uses based on language
  String getUsesForLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'ar':
        return uses2;
      case 'fa':
        return uses1;
      case 'en':
      default:
        return uses;
    }
  }

  // Helper method to get dosage based on language
  String getDosageForLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'ar':
        return dosage2;
      case 'fa':
        return dosage1;
      case 'en':
      default:
        return dosage;
    }
  }
}
