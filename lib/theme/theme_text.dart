import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeText {
  const ThemeText._();

  static TextTheme get _cairoTextTheme => GoogleFonts.cairoTextTheme();

  static TextStyle get _displayMedium =>
      _cairoTextTheme.displayMedium!.copyWith();

  static TextStyle get _displaySmall =>
      _cairoTextTheme.displaySmall!.copyWith();

  static TextStyle get _headlineLarge =>
      _cairoTextTheme.headlineLarge!.copyWith();
  static TextStyle get _headlineMedium =>
      _cairoTextTheme.headlineMedium!.copyWith();
  static TextStyle get _headlineSmall =>
      _cairoTextTheme.headlineSmall!.copyWith();

  static TextStyle get _titleLarge => _cairoTextTheme.titleLarge!.copyWith();
  static TextStyle get _titleMedium => _cairoTextTheme.titleMedium!.copyWith();
  static TextStyle get _titleSmall => _cairoTextTheme.titleSmall!.copyWith();

  static TextStyle get _bodyLarge => _cairoTextTheme.bodyLarge!.copyWith();
  static TextStyle get _bodyMedium => _cairoTextTheme.bodyMedium!.copyWith();
  static TextStyle get _bodySmall => _cairoTextTheme.bodySmall!.copyWith();

  static TextStyle get _labelLarge => _cairoTextTheme.labelLarge!.copyWith();
  static TextStyle get _labelSmall => _cairoTextTheme.labelSmall!.copyWith();

  static TextTheme get lightTextTheme => TextTheme(
        displayMedium: _displayMedium,
        displaySmall: _displaySmall,
        headlineLarge: _headlineLarge,
        headlineMedium: _headlineMedium,
        headlineSmall: _headlineSmall,
        titleLarge: _titleLarge,
        titleMedium: _titleMedium,
        titleSmall: _titleSmall,
        bodyLarge: _bodyLarge,
        bodyMedium: _bodyMedium,
        bodySmall: _bodySmall,
        labelLarge: _labelLarge,
        labelSmall: _labelSmall,
      );
}
