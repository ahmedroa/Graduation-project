import 'package:flutter/material.dart';

import '../theme/colors.dart';

class MainButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool hasCircularBorder;
  final double width;
  final double int;
  final Color color;
  final Color colortext;

  const MainButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.hasCircularBorder = false,
      this.color = ColorsManager.kPrimaryColor,
      this.colortext = Colors.white,
      this.width = double.infinity,
      this.int = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: 40,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(int),
            color: color,
          ),
          child: MaterialButton(
            onPressed: onTap,
            child: Text(
              text,
              style: TextStyle(color: colortext, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ));
  }
}
