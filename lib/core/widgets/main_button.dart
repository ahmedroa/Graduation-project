import 'package:flutter/material.dart';
import 'package:graduation/core/theme/text_styles.dart';

import '../theme/colors.dart';

class MainButton extends StatelessWidget {
  final text;
  final VoidCallback onTap;
  final bool hasCircularBorder;
  final double width;
  final double height;
  final double int;
  final Color color;
  final Color colortext;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget? icon; // إضافة الأيقونة كمتغير اختياري

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
    this.icon, // تمرير الأيقونة كقيمة اختيارية
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8), // مسافة صغيرة بين الأيقونة والنص
              ],
              Text(text, style: TextStyles.font12WhiteMediuAm.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
