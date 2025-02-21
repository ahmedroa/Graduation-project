import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation/core/theme/colors.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    surfaceDim: ColorsManager.backgroundColor,
    seedColor: ColorsManager.kPrimaryColor,
    primary: ColorsManager.kPrimaryColor,
    onPrimary: Colors.white,
    secondary: ColorsManager.dark,
    primaryContainer: ColorsManager.textFormField,
    onPrimaryContainer: ColorsManager.textFormFieldDark,
    // tertiary: ColorsManager.appBarColorDarek,
    tertiary: const Color(0xffEAEAEA),
    tertiaryContainer: const Color(0xffE6E6E6),
    onTertiaryContainer: Colors.white,
  ),
  useMaterial3: true,
  //  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: ColorsManager.backgroundColorDark,
      statusBarIconBrightness: Brightness.dark,
    ),
    centerTitle: true,
    backgroundColor: ColorsManager.appBarColor,
    surfaceTintColor: ColorsManager.appBarColor,
    titleTextStyle: TextStyle(
      color: ColorsManager.dark,
      fontSize: 16,
      // fontWeight: FontWeightHelper.bold,
    ),
  ),
  visualDensity: VisualDensity.comfortable,
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
  ),
  scaffoldBackgroundColor: Colors.white, //
  // primaryTextTheme: Typography.whiteCupertino
);

//
