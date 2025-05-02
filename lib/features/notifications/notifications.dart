import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('img/notifications.png', color: ColorsManager.kPrimaryColor, height: 200, width: 200),
      ),
    );
  }
}
