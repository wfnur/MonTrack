import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        backgroundColor: AppColors.surface,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 68,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primarySurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleTextStyle: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        backgroundColor: AppColors.darkSurface,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 68,
        backgroundColor: AppColors.darkSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        titleTextStyle: AppTextStyles.title.copyWith(color: Colors.white),
      ),
    );
  }
}
