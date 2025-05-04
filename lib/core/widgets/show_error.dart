// دالة لعرض رسائل الخطأ
import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 24),
                horizontalSpace(12),
                Expanded(child: Text(message, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.red.shade800,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      // action: SnackBarAction(
      //   label: 'حسناً',
      //   textColor: Colors.white,
      //   onPressed: () {
      //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //   },
      // ),
    ),
  );
}
