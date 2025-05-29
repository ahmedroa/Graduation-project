import 'package:flutter/material.dart';

Future<Object?> underMaintenance(BuildContext context) {
  return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5), // خلفية شفافة
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  '🚧 تحت الصيانة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text('التطبيق حالياً تحت الصيانة.\nالرجاء المحاولة لاحقاً.', textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
}