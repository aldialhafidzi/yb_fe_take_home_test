import 'package:flutter/material.dart';

class AppButtonStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final BorderSide borderSide;
  final EdgeInsets padding;
  final double? width;
  final double? height;
  final MaterialTapTargetSize tapTargetSize;

  const AppButtonStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.borderSide,
    required this.padding,
    required this.tapTargetSize,
    this.width,
    this.height,
  });
}
