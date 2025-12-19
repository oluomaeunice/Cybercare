
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/constants/sizes.dart';
import 'package:flutter/material.dart';

///-- Light & Dark Elevated Button Themes
class MyElevatedButtonTheme {

  MyElevatedButtonTheme._(); //To avoid creating instances

  ///-- Light Theme

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(

    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primaryLight,
      disabledForegroundColor: AppColors.darkGrey,
      disabledBackgroundColor: AppColors.buttonDisabled,
      padding: const EdgeInsets.symmetric(vertical:AppSizes.buttonHeight),
      textStyle: const TextStyle (
          fontSize: 16, color: AppColors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius)),),

  );

// ElevatedButtonThemeData

  /// Dark Theme

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primaryLight,
      disabledForegroundColor: AppColors.darkGrey,
      disabledBackgroundColor: AppColors.darkerGrey,
      padding: const EdgeInsets.symmetric(vertical:AppSizes.buttonHeight),
      textStyle: const TextStyle(
          fontSize: 16, color: AppColors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius)),
    ),
  );
}