import 'package:flutter/material.dart';
import 'colors.dart';

class AppInputDecorationTheme {
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.lightPrimaryContainer),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.lightPrimaryContainer),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.lightPrimary),
    ),
    labelStyle: TextStyle(
      color: AppColors.lightOnBackground.withValues(alpha: 0.6),
      fontSize: 16.0,
    ),
    hintStyle: TextStyle(
      color: AppColors.lightOnBackground.withValues(alpha: 0.4),
      fontSize: 16.0,
    ),
    errorStyle: const TextStyle(
      color: AppColors.lightError,
      fontSize: 12.0,
    ),
    filled: true,
    fillColor: AppColors.lightSurface,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 16.0,
    ),
    prefixIconColor: AppColors.lightPrimary,
    suffixIconColor: AppColors.lightPrimary,
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.darkPrimaryContainer),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.darkPrimaryContainer),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.darkPrimary),
    ),
    labelStyle: TextStyle(
      color: AppColors.darkOnBackground.withValues(alpha: 0.6),
      fontSize: 16.0,
    ),
    hintStyle: TextStyle(
      color: AppColors.darkOnBackground.withValues(alpha: 0.4),
      fontSize: 16.0,
    ),
    errorStyle: const TextStyle(
      color: AppColors.darkError,
      fontSize: 12.0,
    ),
    filled: true,
    fillColor: AppColors.darkSurface,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 16.0,
    ),
    prefixIconColor: AppColors.darkPrimary,
    suffixIconColor: AppColors.darkPrimary,
  );
}
