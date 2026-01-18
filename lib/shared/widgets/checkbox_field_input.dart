import 'package:flutter/material.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';

class CheckboxFieldInput extends StatelessWidget {
  final bool value;
  final String labelText;
  final ValueChanged<bool> onChanged;

  const CheckboxFieldInput({
    super.key,
    this.labelText = '',
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: value ? primaryDefaultColor : grayscaleBodyTextColor,
                  width: 1.5,
                ),
                color: value ? primaryDefaultColor : Colors.transparent,
              ),
              child: value
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            Visibility(
              visible: labelText.isNotEmpty,
              child: SizedBox(width: 6),
            ),
            Visibility(
              visible: labelText.isNotEmpty,
              child: Text(labelText, style: xSmallTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
