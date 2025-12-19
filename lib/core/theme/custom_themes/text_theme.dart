
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextTheme {
  MyTextTheme._();

  ///controlls the lightTexttheme
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.lobster(
        textStyle: const TextStyle().copyWith(
            fontSize: 30.0, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
    headlineMedium: GoogleFonts.lobster(
        textStyle: const TextStyle().copyWith(
            fontSize: 20.0, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
    headlineSmall: GoogleFonts.lobster(
        textStyle: const TextStyle().copyWith(
            fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
    titleLarge: GoogleFonts.lobster(
        textStyle: const TextStyle().copyWith(
            fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
    titleMedium: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 16.0, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
    titleSmall: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 16.0, fontWeight: FontWeight.w400, color: AppColors.primaryDark)),
    bodyLarge: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
    bodyMedium: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: AppColors.primaryDark)),
    bodySmall: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryDark)),
    labelLarge: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: AppColors.primaryDark)),
    labelMedium: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: AppColors.primaryDark)),
  );

  ///controlls the darkTexttheme
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.lobster(
        textStyle: const TextStyle().copyWith(
            fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white)),
    headlineMedium: GoogleFonts.lobster(
        textStyle: const TextStyle().copyWith(
            fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white)),
    headlineSmall: GoogleFonts.lobster(
        textStyle: const TextStyle().copyWith(
            fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white)),
    titleLarge: GoogleFonts.lobster(
        textStyle: const TextStyle().copyWith(
            fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white)),
    titleMedium: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white)),
    titleSmall: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.white)),
    bodyLarge: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white)),
    bodyMedium: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.white)),
    bodySmall: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Colors.white)),
    labelLarge: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.white)),
    labelMedium: GoogleFonts.robotoCondensed(
        textStyle: const TextStyle().copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.white)),
  );
}
