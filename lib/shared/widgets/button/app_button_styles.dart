import 'package:flutter/material.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'app_button_variant.dart';
import 'app_button_style.dart';

final Map<AppButtonVariant, AppButtonStyle> appButtonStyles = {
  AppButtonVariant.primary: AppButtonStyle(
    backgroundColor: primaryDefaultColor,
    textColor: whiteColor,
    iconColor: whiteColor,
    borderSide: BorderSide.none,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
    width: double.infinity,
    height: 50,
    tapTargetSize: MaterialTapTargetSize.padded,
  ),

  AppButtonVariant.secondary: AppButtonStyle(
    backgroundColor: secondaryColor,
    textColor: grayscaleButtonTextColor,
    iconColor: grayscaleButtonTextColor,
    borderSide: BorderSide(color: Colors.transparent),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
    width: double.infinity,
    height: 50,
    tapTargetSize: MaterialTapTargetSize.padded,
  ),
};
