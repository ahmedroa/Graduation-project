import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';

class NoDataWidget extends StatelessWidget {
  final String? message;
  const NoDataWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_filled, size: 80, color: ColorsManager.kPrimaryColor),
          const SizedBox(height: 16),
          Text(
            message ?? "لا توجد سيارات مبلغ عنها",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          // const Text("اسحب لأسفل للتحديث", style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
