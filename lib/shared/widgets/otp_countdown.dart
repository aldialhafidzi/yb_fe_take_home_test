import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';

class OtpCountdown extends StatefulWidget {
  final int countdownSeconds; // total detik countdown
  const OtpCountdown({super.key, this.countdownSeconds = 60});

  @override
  State<OtpCountdown> createState() => _OtpCountdownState();
}

class _OtpCountdownState extends State<OtpCountdown> {
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _secondsRemaining = widget.countdownSeconds;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _secondsRemaining > 0 ? 'Resend OTP in ' : '',
          style: smallTextStyle.copyWith(color: grayscaleBodyTextColor),
        ),
        Text(
          _secondsRemaining > 0 ? '${_secondsRemaining}s' : '',
          style: smallTextStyle.copyWith(color: errorDarkColor),
        ),
        const SizedBox(width: 4),
        if (_secondsRemaining <= 0)
          InkWell(
            focusColor: transparentColor,
            highlightColor: transparentColor,
            hoverColor: transparentColor,
            splashColor: transparentColor,
            onTap: _secondsRemaining == 0 ? _startCountdown : null,
            child: Text(
              'Resend OTP',
              style: smallTextStyle.copyWith(color: primaryDarkModeColor),
            ),
          ),
      ],
    );
  }
}
