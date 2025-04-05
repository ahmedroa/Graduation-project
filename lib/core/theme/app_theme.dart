import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/font_weight_helper.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    background: ColorsManager.backgroundColor,
    surfaceDim: ColorsManager.backgroundColor,
    seedColor: ColorsManager.kPrimaryColor,
    primary: ColorsManager.kPrimaryColor,
    onPrimary: Colors.white,
    secondary: ColorsManager.dark,
    primaryContainer: ColorsManager.textFormField,
    onPrimaryContainer: ColorsManager.textFormFieldDark,
    tertiary: const Color(0xffEAEAEA),
    tertiaryContainer: const Color(0xffE6E6E6),
    onTertiaryContainer: Colors.white,
  ),
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: ColorsManager.kPrimaryColor),
    backgroundColor: ColorsManager.appBarColor,
    titleTextStyle: TextStyle(color: ColorsManager.dark, fontSize: 18, fontWeight: FontWeightHelper.bold),
  ),
  visualDensity: VisualDensity.comfortable,
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
  ),
  scaffoldBackgroundColor: Colors.white,
);
