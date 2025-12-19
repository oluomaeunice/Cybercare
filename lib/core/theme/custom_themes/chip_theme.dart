import 'package:cybercare/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MyChipTheme {

  MyChipTheme._();

static ChipThemeData lightChipTheme = ChipThemeData(

  disabledColor: Colors.grey.withOpacity(0.4),

  labelStyle: const TextStyle(color: Colors.black),

  selectedColor: AppColors.primaryDark,

  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),

  checkmarkColor: Colors.white,
  color: MaterialStatePropertyAll(AppColors.primaryDark),
  side: BorderSide.none
); // Chip ThemeData

static ChipThemeData darkChipTheme = const ChipThemeData(

  disabledColor: Colors.grey,

  labelStyle: TextStyle (color: Colors.white),

  selectedColor: AppColors.primaryDark,

  padding: EdgeInsets.symmetric (horizontal: 12.0, vertical: 12),

  checkmarkColor: Colors.white,
    color: MaterialStatePropertyAll(AppColors.primaryDark)
)

; // ChipThemeData

}