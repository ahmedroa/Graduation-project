import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildSearchResultItem extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final Function()? onTap;

  const BuildSearchResultItem({super.key, required this.doc, this.onTap});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        title: Text(
          data['name'] ?? 'سيارة',
          style: TextStyle(fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('النوع: ${data['typeCar'] ?? ''}', textDirection: TextDirection.rtl),
            Text('الموديل: ${data['model'] ?? ''}', textDirection: TextDirection.rtl),
            Text('رقم اللوحة: ${data['plateNumber'] ?? ''}', textDirection: TextDirection.rtl),
            Text('المدينة: ${data['city'] ?? ''}', textDirection: TextDirection.rtl),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
