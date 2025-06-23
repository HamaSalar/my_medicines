// lib/widgets/medicine_type_card.dart
import 'package:flutter/material.dart';
import '../models/medicine_type.dart';

class MedicineTypeCard extends StatelessWidget {
  final MedicineType medicineType;
  final VoidCallback onTap;

  const MedicineTypeCard({
    super.key,
    required this.medicineType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Download indicator
            if (medicineType.isDownloaded)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(right: 8, top: 8),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),

            // Type icon
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade700
                        : Colors.blue.shade100,
              ),
              child: Center(child: _getTypeIcon(medicineType.name)),
            ),
            SizedBox(height: 16),

            // Type name
            Text(
              medicineType.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // Download indicator text
            if (medicineType.isDownloaded)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Available Offline',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getTypeIcon(String typeName) {
    // Return appropriate icon based on medicine type
    switch (typeName.toLowerCase()) {
      case 'pills':
        return Icon(Icons.medication, size: 40, color: Colors.blue);
      case 'injections':
        return Icon(Icons.vaccines, size: 40, color: Colors.red);
      case 'capsules':
        return Icon(Icons.medical_information, size: 40, color: Colors.orange);
      case 'creams':
        return Icon(Icons.sanitizer, size: 40, color: Colors.green);
      case 'syrup':
        return Icon(Icons.local_drink, size: 40, color: Colors.purple);
      default:
        return Icon(Icons.medical_services, size: 40, color: Colors.blue);
    }
  }
}
