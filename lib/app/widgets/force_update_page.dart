import 'package:flutter/material.dart';

class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AlertDialog(
          title: const Text('تحديث جديد متوفر'),
          content: const Text('يجب تحديث التطبيق للاستمرار في استخدامه.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // افتح رابط المتجر
                // launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.example.yourapp"));
              },
              child: const Text('تحديث الآن'),
            ),
          ],
        ),
      ),
    );
  }
}
