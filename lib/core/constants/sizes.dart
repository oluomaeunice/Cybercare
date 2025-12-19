


import 'package:flutter/material.dart';

class AppSizes {
  final BuildContext context;
  AppSizes(this.context);

  // Screen dimensions
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
// Padding and margin sizes
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;


// Icon sizes
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

// Font sizes
  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeLg = 18.0;

// Button sizes

  static const double buttonHeight = 18.0;
  static const double buttonRadius = 12.0;
  static const double buttonWidth = 120.0;
  static const double buttonElevation = 4.0;

  // Percentage-based helpers
  double wp(double percent) => width * (percent / 100); // Width percentage
  double hp(double percent) => height * (percent / 100); // Height percentage

}
