import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.roboto(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: AppColors.lightOnBackground,
    ),
    displayMedium: GoogleFonts.roboto(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: AppColors.lightOnBackground,
    ),
    headlineLarge: GoogleFonts.roboto(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: AppColors.lightOnBackground,
    ),
    headlineMedium: GoogleFonts.roboto(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: AppColors.lightOnBackground,
    ),
    headlineSmall: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: AppColors.lightOnBackground,
    ),
    titleLarge: GoogleFonts.roboto(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.lightOnBackground,
    ),
    titleMedium: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.lightOnBackground,
    ),
    titleSmall: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightOnBackground,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.lightOnBackground,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.lightOnBackground.withOpacity(0.7),
    ),
    labelLarge: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightOnPrimary,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.lightOnBackground.withOpacity(0.6),
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.roboto(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: AppColors.darkOnBackground,
    ),
    displayMedium: GoogleFonts.roboto(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: AppColors.darkOnBackground,
    ),
    headlineLarge: GoogleFonts.roboto(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: AppColors.darkOnBackground,
    ),
    headlineMedium: GoogleFonts.roboto(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: AppColors.darkOnBackground,
    ),
    headlineSmall: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: AppColors.darkOnBackground,
    ),
    titleLarge: GoogleFonts.roboto(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.darkOnBackground,
    ),
    titleMedium: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.darkOnBackground,
    ),
    titleSmall: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkOnBackground,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.darkOnBackground,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.darkOnBackground.withOpacity(0.7),
    ),
    labelLarge: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkOnPrimary,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.darkOnBackground.withOpacity(0.6),
    ),
  );
}
