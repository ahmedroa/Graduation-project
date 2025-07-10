import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';

class BuildSearchResultItem extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final Function()? onTap;

  const BuildSearchResultItem({super.key, required this.doc, this.onTap});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Image.network(data['image'], height: 100),
              ),
              horizontalSpace(12),
              Column(
                children: [
                  Text(
                    data['name'] ?? 'سيارة',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                  Text('${data['typeCar'] ?? ''}', textDirection: TextDirection.rtl),
                ],
              ),
              Spacer(),
              data['stolen'] == true
                  ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFF4D4D).withOpacity(0.16),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text("مفقودة", style: TextStyle(fontSize: 16, color: Color(0xffFF4D4D))),
                    ),
                  )
                  : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff0070D1).withOpacity(0.16),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text("موجوده", style: TextStyle(fontSize: 16, color: Color(0xff0070D1))),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}



        // onTap: onTap,

// Text(
//           data['name'] ?? 'سيارة',
//           style: TextStyle(fontWeight: FontWeight.bold),
//           textDirection: TextDirection.rtl,
//         ),
            // Text('النوع: ${data['typeCar'] ?? ''}', textDirection: TextDirection.rtl),
            // Text('الموديل: ${data['model'] ?? ''}', textDirection: TextDirection.rtl),
            // Text('رقم اللوحة: ${data['plateNumber'] ?? ''}', textDirection: TextDirection.rtl),
            // Text('المدينة: ${data['city'] ?? ''}', textDirection: TextDirection.rtl),