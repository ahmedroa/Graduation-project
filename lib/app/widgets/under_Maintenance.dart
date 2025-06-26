import 'dart:ui';

import 'package:flutter/material.dart';

Future<Object?> underMaintenance(BuildContext context) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5), // يخلي الخلفية فيها شفافية
    barrierDismissible: false,
    builder:
        (_) => Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // يعطي تأثير بلور للخلفية
              child: AlertDialog(
                backgroundColor: Colors.white.withOpacity(0.9), // شفافية داخل الديالوج
                title: const Text('🚧 تحت الصيانة'),
                content: const Text('التطبيق حالياً تحت الصيانة , الرجاء المحاولة لاحقاً.'),
              ),
            ),
          ),
        ),
  );
}
