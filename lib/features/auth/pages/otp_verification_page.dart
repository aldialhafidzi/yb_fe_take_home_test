import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/widgets/button/app_button.dart';
import 'package:yb_fe_take_home_test/shared/widgets/custom_app_bar.dart';
import 'package:yb_fe_take_home_test/shared/widgets/otp_field_input.dart';
import 'package:yb_fe_take_home_test/shared/widgets/otp_countdown.dart';
import 'package:yb_fe_take_home_test/core/providers/auth_provider.dart';

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
    final auth = ref.read(authProvider.notifier);

    try {
      setState(() {
        _loading = true;
      });

      await auth.verifyOtp(_otpText);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Verifikasi OTP berhasil!')));

      context.go('/home');
    } catch (e) {
      print('error: $e');
      _errorText = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: errorDarkColor),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 150,
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
      bottomNavigationBar: BottomAppBar(
        color: whiteColor,
        surfaceTintColor: whiteColor,
        shadowColor: whiteColor,
        padding: EdgeInsets.symmetric(horizontal: 24),
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
    );
  }
}
