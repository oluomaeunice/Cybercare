import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/theme/custom_themes/appbar_theme.dart';
import 'package:cybercare/core/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:cybercare/core/theme/custom_themes/chip_theme.dart';
import 'package:cybercare/core/theme/custom_themes/elevated_button_theme.dart';
import 'package:cybercare/core/theme/custom_themes/outline_button_theme.dart';
import 'package:cybercare/core/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

import 'custom_themes/text_field_theme.dart' show MyTextFormFieldTheme;


class AppTheme{
  AppTheme._();

  ///controlls the light theme
  static ThemeData lightTheme= ThemeData(
    useMaterial3: true,
    fontFamily: 'outfit',
    brightness: Brightness.light,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.primaryDark,
    textTheme: MyTextTheme.darkTextTheme,
    chipTheme: MyChipTheme.lightChipTheme,
    appBarTheme: MyAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: MyBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: MyTextFormFieldTheme.lightInputDecorationTheme,
    textSelectionTheme: MyTextFormFieldTheme.TextSelectionTheme,

  );

  ///controlls the darktheme
  static ThemeData darkTheme= ThemeData(
    useMaterial3: true,
    fontFamily: 'outfit',
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.black,
    textTheme: MyTextTheme.darkTextTheme,
    chipTheme: MyChipTheme.darkChipTheme,
    appBarTheme: MyAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: MyBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: MyTextFormFieldTheme.darkInputDecorationTheme,
    textSelectionTheme: MyTextFormFieldTheme.TextSelectionTheme,
  );
}
