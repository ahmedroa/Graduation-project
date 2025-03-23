import 'package:flutter/material.dart';

import '../theme/colors.dart';

class MainButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool hasCircularBorder;
  final double width;
  final double height;
  final double int;
  // ignore: non_constant_identifier_names
  final Color color;
  final Color colortext;
  final double fontSize;
  final FontWeight fontWeight;

  const MainButton({
    super.key,
    required this.text,
    required this.onTap,
    this.hasCircularBorder = false,
    this.color = ColorsManager.kPrimaryColor,
    this.colortext = Colors.white,
    this.width = double.infinity,
    this.height = 50,
    this.fontSize = 20,
    this.int = 10,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(int), color: color),
        child: MaterialButton(
          onPressed: onTap,
          child: Text(text, style: TextStyle(color: colortext, fontSize: fontSize, fontWeight: fontWeight)),
        ),
      ),
    );
  }
}
