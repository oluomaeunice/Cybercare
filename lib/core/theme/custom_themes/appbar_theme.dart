
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppBarTheme{

  MyAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme (
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: AppColors.black, size:AppSizes.iconMd),
    actionsIconTheme: IconThemeData(color: AppColors.black, size:AppSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.black),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // dark icons for light backgrounds
      statusBarBrightness: Brightness.light,    // iOS
    ),
  );

//
  static const darkAppBarTheme = AppBarTheme (
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: AppColors.black, size:AppSizes.iconMd),
    actionsIconTheme: IconThemeData(color: AppColors.white, size:AppSizes.iconMd),
    titleTextStyle: TextStyle (fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.white),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // light icons for dark backgrounds
      statusBarBrightness: Brightness.dark,      // iOS
    ),
  );
}