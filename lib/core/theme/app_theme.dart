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
      outline: AppColors.lightOutline,
      error: AppColors.lightError,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onSurface: AppColors.lightOnSurface,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      onError: AppColors.lightOnError,
      brightness: Brightness.light,
    ),
    textTheme: AppTextTheme.lightTextTheme,
    inputDecorationTheme: AppInputDecorationTheme.lightInputDecorationTheme,
    elevatedButtonTheme: AppButtonTheme.lightElevatedButtonTheme,
    textButtonTheme: AppButtonTheme.lightTextButtonTheme,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTextTheme.lightTextTheme.titleLarge?.copyWith(
        color: AppColors.lightOnSurface,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: AppColors.lightOnSurface),
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.lightOutline.withValues(alpha: 0.1),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.lightOnSurface,
      size: 24.0,
    ),
    cardTheme: CardTheme(
      color: AppColors.lightSurface,
      elevation: 3,
      shadowColor: AppColors.lightOutline.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.lightOutline, width: 0.5),
      ),
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
      outline: AppColors.darkOutline,
      error: AppColors.darkError,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      onError: AppColors.darkOnError,
      brightness: Brightness.dark,
    ),
    textTheme: AppTextTheme.darkTextTheme,
    inputDecorationTheme: AppInputDecorationTheme.darkInputDecorationTheme,
    elevatedButtonTheme: AppButtonTheme.darkElevatedButtonTheme,
    textButtonTheme: AppButtonTheme.darkTextButtonTheme,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTextTheme.darkTextTheme.titleLarge?.copyWith(
        color: AppColors.darkOnSurface,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkOnSurface),
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.darkOutline.withValues(alpha: 0.2),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.darkOnSurface,
      size: 24.0,
    ),
    cardTheme: CardTheme(
      color: AppColors.darkSurface,
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.darkOutline, width: 0.5),
      ),
    ),
  );
}
