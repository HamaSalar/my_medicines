// lib/models/medicine_type.dart
class MedicineType {
  final int id;
  final String name;
  final String image;
  bool isDownloaded;

  MedicineType({
    required this.id,
    required this.name,
    required this.image,
    this.isDownloaded = false,
  });

  factory MedicineType.fromJson(Map<String, dynamic> json) {
    return MedicineType(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      isDownloaded: json['isDownloaded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'isDownloaded': isDownloaded,
    };
  }

  MedicineType copyWith({
    int? id,
    String? name,
    String? image,
    bool? isDownloaded,
  }) {
    return MedicineType(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}
