import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand colors (same in both modes)
  static const Color primary = Color(0xFF1259C3);
  static const Color primarySurface = Color(0xFFE8F0FE);
  static const Color income = Color(0xFF00B09B);
  static const Color expense = Color(0xFFFF4757);

  // Light mode
  static const Color background = Color(0xFFF3F3F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF737373);
  static const Color border = Color(0xFFE0E0E0);

  // Dark mode
  static const Color darkPrimary = Color(0xFF5B8DEF);
  static const Color darkPrimarySurface = Color(0xFF1A3050);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
  static const Color darkBorder = Color(0xFF2C2C2C);
  static const Color darkInputFill = Color(0xFF2C2C2C);
}

/// Extension providing theme-aware colors resolved from context.
extension AppColorsX on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get colorPrimary => _isDark ? AppColors.darkPrimary : AppColors.primary;
  Color get colorPrimarySurface => _isDark ? AppColors.darkPrimarySurface : AppColors.primarySurface;
  Color get colorBackground => _isDark ? AppColors.darkBackground : AppColors.background;
  Color get colorSurface => _isDark ? AppColors.darkSurface : AppColors.surface;
  Color get colorTextPrimary => _isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get colorTextSecondary => _isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get colorBorder => _isDark ? AppColors.darkBorder : AppColors.border;
  Color get colorInputFill => _isDark ? AppColors.darkInputFill : AppColors.background;
}
