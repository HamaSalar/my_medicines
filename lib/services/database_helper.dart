// lib/services/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/medicine.dart';
import '../models/medicine_type.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'medicines.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create medicine types table
    await db.execute('''
      CREATE TABLE medicine_types(
        id INTEGER PRIMARY KEY,
        name TEXT,
        image TEXT,
        isDownloaded INTEGER
      )
    ''');

    // Create medicines table
    await db.execute('''
      CREATE TABLE medicines(
        id INTEGER PRIMARY KEY,
        name TEXT,
        other_names TEXT,
        description TEXT,
        description1 TEXT,
        description2 TEXT,
        uses TEXT,
        uses1 TEXT,
        uses2 TEXT,
        dosage TEXT,
        dosage1 TEXT,
        dosage2 TEXT,
        type_id INTEGER,
        type_name TEXT,
        FOREIGN KEY(type_id) REFERENCES medicine_types(id)
      )
    ''');
  }

  // Medicine Types Operations
  Future<int> insertMedicineType(MedicineType type) async {
    Database db = await database;
    return await db.insert('medicine_types', {
      'id': type.id,
      'name': type.name,
      'image': type.image,
      'isDownloaded': type.isDownloaded ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MedicineType>> getMedicineTypes() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medicine_types');
    return List.generate(maps.length, (i) {
      return MedicineType(
        id: maps[i]['id'],
        name: maps[i]['name'],
        image: maps[i]['image'],
        isDownloaded: maps[i]['isDownloaded'] == 1,
      );
    });
  }

  Future<void> updateMedicineTypeDownloadStatus(
    int typeId,
    bool isDownloaded,
  ) async {
    Database db = await database;
    await db.update(
      'medicine_types',
      {'isDownloaded': isDownloaded ? 1 : 0},
      where: 'id = ?',
      whereArgs: [typeId],
    );
  }

  // Medicines Operations
  Future<int> insertMedicine(Medicine medicine) async {
    Database db = await database;
    return await db.insert('medicines', {
      'id': medicine.id,
      'name': medicine.name,
      'other_names': medicine.otherNames,
      'description': medicine.description,
      'description1': medicine.description1,
      'description2': medicine.description2,
      'uses': medicine.uses,
      'uses1': medicine.uses1,
      'uses2': medicine.uses2,
      'dosage': medicine.dosage,
      'dosage1': medicine.dosage1,
      'dosage2': medicine.dosage2,
      'type_id': medicine.typeId,
      'type_name': medicine.typeName,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Medicine>> getMedicinesByType(int typeId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicines',
      where: 'type_id = ?',
      whereArgs: [typeId],
    );
    return List.generate(maps.length, (i) {
      return Medicine(
        id: maps[i]['id'],
        name: maps[i]['name'],
        otherNames: maps[i]['other_names'],
        description: maps[i]['description'],
        description1: maps[i]['description1'],
        description2: maps[i]['description2'],
        uses: maps[i]['uses'],
        uses1: maps[i]['uses1'],
        uses2: maps[i]['uses2'],
        dosage: maps[i]['dosage'],
        dosage1: maps[i]['dosage1'],
        dosage2: maps[i]['dosage2'],
        typeId: maps[i]['type_id'],
        typeName: maps[i]['type_name'],
        isFavorite: false,
      );
    });
  }

  Future<List<Medicine>> searchMedicines(String query) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicines',
      where: 'name LIKE ? OR other_names LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Medicine(
        id: maps[i]['id'],
        name: maps[i]['name'],
        otherNames: maps[i]['other_names'],
        description: maps[i]['description'],
        description1: maps[i]['description1'],
        description2: maps[i]['description2'],
        uses: maps[i]['uses'],
        uses1: maps[i]['uses1'],
        uses2: maps[i]['uses2'],
        dosage: maps[i]['dosage'],
        dosage1: maps[i]['dosage1'],
        dosage2: maps[i]['dosage2'],
        typeId: maps[i]['type_id'],
        typeName: maps[i]['type_name'],
        isFavorite: false,
      );
    });
  }

  // Download management
  Future<bool> isTypeDownloaded(int typeId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'medicine_types',
      columns: ['isDownloaded'],
      where: 'id = ?',
      whereArgs: [typeId],
    );

    if (result.isNotEmpty) {
      return result.first['isDownloaded'] == 1;
    }
    return false;
  }

  Future<void> clearMedicinesByType(int typeId) async {
    Database db = await database;
    await db.delete('medicines', where: 'type_id = ?', whereArgs: [typeId]);
  }
}
