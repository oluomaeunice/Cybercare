import 'package:cybercare/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
/*

Light & Dark Outlined Button Themes -- */

class MyOutlinedButtonTheme {

  MyOutlinedButtonTheme._(); //To avoid creating instances


  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(

      style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.black,
          side: BorderSide (color: AppColors.primaryLight),
          textStyle: const TextStyle (fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  )
  );


/* Dark Theme --*/

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
  foregroundColor: Colors.white,
  side: BorderSide (color: AppColors.primaryDark),
  textStyle: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

  ),

  );

}