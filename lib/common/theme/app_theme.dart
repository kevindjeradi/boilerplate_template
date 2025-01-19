// lib/common/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_theme.dart';
import 'input_decoration_theme.dart';
import 'button_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      surface: AppColors.lightSurface,
      error: AppColors.lightError,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onSurface: AppColors.lightOnSurface,
      onError: AppColors.lightOnError,
      brightness: Brightness.light,
    ),
    textTheme: AppTextTheme.lightTextTheme,
    inputDecorationTheme: AppInputDecorationTheme.lightInputDecorationTheme,
    elevatedButtonTheme: AppButtonTheme.lightElevatedButtonTheme,
    textButtonTheme: AppButtonTheme.lightTextButtonTheme,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      titleTextStyle: AppTextTheme.lightTextTheme.titleLarge?.copyWith(
        color: AppColors.lightOnPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.lightOnPrimary),
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.lightOnPrimary,
      size: 24.0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      surface: AppColors.darkSurface,
      error: AppColors.darkError,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onSurface: AppColors.darkOnSurface,
      onError: AppColors.darkOnError,
      brightness: Brightness.dark,
    ),
    textTheme: AppTextTheme.darkTextTheme,
    inputDecorationTheme: AppInputDecorationTheme.darkInputDecorationTheme,
    elevatedButtonTheme: AppButtonTheme.darkElevatedButtonTheme,
    textButtonTheme: AppButtonTheme.darkTextButtonTheme,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      titleTextStyle: AppTextTheme.darkTextTheme.titleLarge?.copyWith(
        color: AppColors.darkOnPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkOnPrimary),
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.darkOnPrimary,
      size: 24.0,
    ),
  );
}
