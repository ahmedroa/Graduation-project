import 'dart:ui';

import 'package:flutter/material.dart';

Future<dynamic> updateRequest(BuildContext context) {
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
                  title: const Text('📢 تحديث مطلوب'),
                  content: const Text('يوجد إصدار جديد من التطبيق. الرجاء التحديث للاستمرار.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('تحديث الآن'),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
}
