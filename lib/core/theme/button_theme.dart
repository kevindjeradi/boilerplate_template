import 'package:flutter/material.dart';
import 'colors.dart';

class AppButtonTheme {
  static ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: AppColors.lightOnPrimary,
      backgroundColor: AppColors.lightPrimary,
      minimumSize: const Size(double.infinity, 48.0),
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      shadowColor: AppColors.lightPrimaryContainer.withValues(alpha: 0.5),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.lightPrimaryContainer.withValues(alpha: 0.12);
          }
          return null;
        },
      ),
    ),
  );

  static ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: AppColors.darkOnPrimary,
      backgroundColor: AppColors.darkPrimary,
      minimumSize: const Size(double.infinity, 48.0),
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      shadowColor: AppColors.darkPrimaryContainer.withValues(alpha: 0.5),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.darkPrimaryContainer.withValues(alpha: 0.12);
          }
          return null;
        },
      ),
    ),
  );

  static TextButtonThemeData lightTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.lightPrimary,
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.lightPrimaryContainer.withValues(alpha: 0.04);
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.lightPrimaryContainer.withValues(alpha: 0.12);
          }
          return null;
        },
      ),
    ),
  );

  static TextButtonThemeData darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.darkPrimary,
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.darkPrimaryContainer.withValues(alpha: 0.04);
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.darkPrimaryContainer.withValues(alpha: 0.12);
          }
          return null;
        },
      ),
    ),
  );
}
