import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';

void setupErrorState(BuildContext context, String errorMessage) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          icon: const Icon(Icons.error, color: Colors.red, size: 32),
          content: Text(errorMessage, style: TextStyles.font15DarkBlueMedium),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('رجوع', style: TextStyles.font15DarkBlueMedium.copyWith(color: ColorsManager.kPrimaryColor)),
            ),
          ],
        ),
  );
}
