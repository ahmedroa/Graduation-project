import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorsManager.kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                color: Color(0xffF5F5F5).withAlpha(30),
              ),
              // child: const Icon(Icons.wifi_off, size: 100, color: Colors.white),
              child: Image.asset('img/error.jpg'),
            ),
            const SizedBox(height: 20),
            Text("حدث خطأ غير متوقع 😞", style: TextStyle(color: Colors.black, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
