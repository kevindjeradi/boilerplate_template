import 'package:boilerplate_template/common/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class AppInputDecorationTheme {
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.marginSmall),
      borderSide: const BorderSide(color: AppColors.lightPrimaryContainer),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.marginSmall),
      borderSide: const BorderSide(color: AppColors.lightPrimaryContainer),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.marginSmall),
      borderSide: const BorderSide(color: AppColors.lightPrimary),
    ),
    labelStyle: TextStyle(
      color: AppColors.lightOnBackground.withOpacity(0.6),
      fontSize: AppSizes.textMedium,
    ),
    hintStyle: TextStyle(
      color: AppColors.lightOnBackground.withOpacity(0.4),
      fontSize: AppSizes.textMedium,
    ),
    errorStyle: const TextStyle(
      color: AppColors.lightError,
      fontSize: AppSizes.textSmall,
    ),
    filled: true,
    fillColor: AppColors.lightSurface,
    contentPadding: const EdgeInsets.symmetric(
      vertical: AppSizes.paddingSmall,
      horizontal: AppSizes.paddingMedium,
    ),
    prefixIconColor: AppColors.lightPrimary,
    suffixIconColor: AppColors.lightPrimary,
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.marginSmall),
      borderSide: const BorderSide(color: AppColors.darkPrimaryContainer),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.marginSmall),
      borderSide: const BorderSide(color: AppColors.darkPrimaryContainer),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.marginSmall),
      borderSide: const BorderSide(color: AppColors.darkPrimary),
    ),
    labelStyle: TextStyle(
      color: AppColors.darkOnBackground.withOpacity(0.6),
      fontSize: AppSizes.textMedium,
    ),
    hintStyle: TextStyle(
      color: AppColors.darkOnBackground.withOpacity(0.4),
      fontSize: AppSizes.textMedium,
    ),
    errorStyle: const TextStyle(
      color: AppColors.darkError,
      fontSize: AppSizes.textSmall,
    ),
    filled: true,
    fillColor: AppColors.darkSurface,
    contentPadding: const EdgeInsets.symmetric(
      vertical: AppSizes.paddingSmall,
      horizontal: AppSizes.paddingMedium,
    ),
    prefixIconColor: AppColors.darkPrimary,
    suffixIconColor: AppColors.darkPrimary,
  );
}
