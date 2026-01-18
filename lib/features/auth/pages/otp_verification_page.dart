import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/widgets/button/app_button.dart';
import 'package:yb_fe_take_home_test/shared/widgets/otp_field_input.dart';
import 'package:yb_fe_take_home_test/shared/widgets/otp_countdown.dart';
import '../../../core/providers/auth_provider.dart';

class OTPVerificationPage extends ConsumerStatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  ConsumerState<OTPVerificationPage> createState() =>
      _OTPVerificationPageState();
}

class _OTPVerificationPageState extends ConsumerState<OTPVerificationPage> {
  String? _errorText;
  String _otpText = '';
  bool _loading = false;

  void _verifyOTP() async {
    final auth = ref.read(authProvider);

    try {
      setState(() {
        _loading = true;
      });
      bool success = await auth.loginOTP(_otpText);
      if (success) {
        print("OTP: $_otpText");
      } else {
        _errorText = 'Invalid OTP';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verifikasi OTP Gagal: Kode OTP tidak valid!'),
            backgroundColor: errorDarkColor,
          ),
        );
      }
    } catch (e) {
      print('error: $e');
      _errorText = 'Invalid OTP';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verifikasi OTP Gagal: Kode OTP tidak valid!'),
          backgroundColor: errorDarkColor,
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/login');
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 56,
              ),
              child: IntrinsicHeight(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 450),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Text(
                                'OTP Verification',
                                style: mediumBoldTextStyle,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Enter the OTP sent to ${user?.email ?? ''}',
                              style: mediumTextStyle,
                            ),
                            SizedBox(height: 27),
                            OtpInputField(
                              length: 4,
                              errorText: _errorText,
                              onCompleted: (otp) {
                                setState(() {
                                  _otpText = otp;
                                });
                              },
                            ),
                            SizedBox(height: 27),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [OtpCountdown(countdownSeconds: 60)],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 450),
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      offset: Offset(0, -2),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 450),
                    child: AppButton(
                      onPressed: _verifyOTP,
                      label: 'Verify',
                      isLoading: _loading,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
