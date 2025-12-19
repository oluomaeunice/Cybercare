import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, system }

extension ThemeModeExtension on AppThemeMode {
  ThemeMode get toThemeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
      default:
        return ThemeMode.system;
    }
  }
}