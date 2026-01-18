import 'package:flutter/material.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'app_button_variant.dart';
import 'app_button_style.dart';
import 'app_button_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final bool isLoading;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final AppButtonStyle style = appButtonStyles[variant]!;

    return SizedBox(
      width: width ?? style.width,
      height: style.height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: style.backgroundColor,
          padding: style.padding,
          tapTargetSize: style.tapTargetSize,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: style.borderSide,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    SizedBox(child: leadingIcon),
                    const SizedBox(width: 10),
                  ],

                  Text(
                    label,
                    style: linkMediumTextStyle.copyWith(color: style.textColor),
                  ),

                  if (suffixIcon != null) ...[
                    const SizedBox(width: 10),
                    SizedBox(child: suffixIcon),
                  ],
                ],
              ),
      ),
    );
  }
}
