import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/sizes.dart';
import 'theme_text.dart';

class AppTheme {
  const AppTheme._();

  static const Color cyanAccent = Color(0xFF88DDB5);
  static const Color cyan = Color(0xFF19C5BC);
  static const Color blue = Color(0xFF025AB5);

  static const Color red = Color(0xFFC22B2B);
  static const Color orange = Color(0xFFFAB001);
  static const Color green = Color(0xFF02B55A);

  static const Color lighterGrey = Color(0xFFF9FBFC);
  static const Color lightGrey = Color(0xFFF0F4F8);
  static const Color lightGrey2 = Color(0xFFDDDDDD);
  static const Color mediumGrey = Color(0xFFACBFCF);
  static const Color grey = Color(0xFF748A9D);

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static ColorScheme lightColorScheme = ColorScheme.fromSwatch().copyWith(
    brightness: Brightness.light,
    primary: cyan,
    secondary: cyan,
    background: white,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: lightColorScheme.brightness,
      primaryColor: lightColorScheme.primary,
      scaffoldBackgroundColor: lightColorScheme.background,
      unselectedWidgetColor: grey,
      colorScheme: lightColorScheme,
      textTheme: ThemeText.lightTextTheme,
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: ThemeText.lightTextTheme.bodyLarge!.copyWith(
          color: white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          foregroundColor: black,

          minimumSize: const Size(Sizes.s150, Sizes.s50),
        ),
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        elevation: Sizes.s0,
        scrolledUnderElevation: Sizes.s0,
        backgroundColor: Colors.transparent,
        foregroundColor: black,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
    );
  }
}
