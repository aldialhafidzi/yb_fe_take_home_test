import 'package:flutter/material.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';

class TextFieldInput extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final bool clearableText;
  final bool requiredInput;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const TextFieldInput({
    super.key,
    required this.labelText,
    this.hintText = '',
    this.requiredInput = false,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.clearableText = false,
  });

  @override
  State<TextFieldInput> createState() => TextFieldInputState();
}

class TextFieldInputState extends State<TextFieldInput> {
  String? errorText;

  void reset() {
    setState(() {
      widget.controller?.clear();
      errorText = null;
    });
  }

  String? validate(String? value, bool showResult) {
    String? result;

    if (widget.requiredInput && (value == null || value.isEmpty)) {
      result = '${widget.labelText} is required';
    }

    if (result == null && widget.validator != null) {
      result = widget.validator!(value);
    }

    if (showResult) return result;

    setState(() {
      errorText = result;
    });

    return result != null ? '' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.labelText != '') Text(widget.labelText),
            if (widget.requiredInput)
              Text('*', style: TextStyle(color: errorDarkColor)),
          ],
        ),
        const SizedBox(height: 4),
        Column(
          children: [
            TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              validator: (value) => validate(value, false),
              onChanged: (value) {
                String? result;
                result = validate(value, true);
                setState(() {
                  errorText = result == '' ? null : result;
                });
              },
              decoration: InputDecoration(
                filled: true,
                errorText: null,
                error: null,
                helperText: null,
                counterText: '',
                errorStyle: TextStyle(fontSize: 0, height: 2),
                hintText: widget.hintText,
                hintStyle: smallTextStyle.copyWith(color: grayscaleColor),
                fillColor: errorText != null ? errorLightColor : whiteColor,
                prefixIcon: widget.prefixIcon,
                suffixIcon: (errorText != null && widget.clearableText)
                    ? IconButton(
                        onPressed: reset,
                        icon: Icon(Icons.close),
                        focusColor: transparentColor,
                        highlightColor: transparentColor,
                        hoverColor: transparentColor,
                      )
                    : widget.suffixIcon,
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(
                    color: grayscaleBodyTextColor,
                    width: 1,
                  ),
                ),
              ),
            ),

            if (errorText != null)
              Column(
                children: [
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: errorDarkColor,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          errorText!,
                          style: smallTextStyle.copyWith(color: errorDarkColor),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
