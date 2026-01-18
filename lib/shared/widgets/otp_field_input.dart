import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';

class OtpInputField extends StatefulWidget {
  final int length;
  final String? errorText;
  final Function(String) onCompleted;

  const OtpInputField({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.errorText,
  });

  @override
  _OtpInputFieldState createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    _controllers.forEach((c) => c.dispose());
    _focusNodes.forEach((f) => f.dispose());
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    String otp = _controllers.map((c) => c.text).join();
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.length, (index) {
            return SizedBox(
              width: 64,
              height: 64,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: mediumBoldTextStyle.copyWith(height: 1.2),
                decoration: InputDecoration(
                  filled: true,
                  counterText: '',
                  fillColor: widget.errorText != null
                      ? errorLightColor
                      : whiteColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? errorDarkColor
                          : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      width: 2,
                      color: widget.errorText != null
                          ? errorDarkColor
                          : Colors.blue,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: errorDarkColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(width: 2, color: errorDarkColor),
                  ),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => _onChanged(value, index),
              ),
            );
          }),
        ),

        if (widget.errorText != null)
          Column(
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: errorDarkColor),
                  SizedBox(width: 4),
                  Text(
                    widget.errorText!,
                    style: smallTextStyle.copyWith(color: errorDarkColor),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
