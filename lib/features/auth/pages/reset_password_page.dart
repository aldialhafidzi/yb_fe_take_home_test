import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/utils/validator.dart';
import 'package:yb_fe_take_home_test/shared/widgets/button/app_button.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newConfirmationPasswordController =
      TextEditingController();

  final GlobalKey<TextFieldInputState> _newPasswordKey =
      GlobalKey<TextFieldInputState>();

  final GlobalKey<TextFieldInputState> _newConfirmationPasswordKey =
      GlobalKey<TextFieldInputState>();

  bool _obscureNewPassword = true;
  bool _obscureConfirmationPassword = true;

  final _formKey = GlobalKey<FormState>();

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      String newPassword = _newPasswordController.text;
      String confirmationPassword = _newConfirmationPasswordController.text;

      print("newPassword: $newPassword");
      print("confirmationPassword: $confirmationPassword");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Reset password berhasil!')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 450),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                'Reset Password',
                                style: mediumBoldTextStyle,
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFieldInput(
                              key: _newPasswordKey,
                              obscureText: _obscureNewPassword,
                              labelText: 'New Password',
                              controller: _newPasswordController,
                              validator: (value) => Validator.password(value),
                              requiredInput: true,
                              suffixIcon: IconButton(
                                focusColor: transparentColor,
                                highlightColor: transparentColor,
                                hoverColor: transparentColor,
                                icon: _obscureNewPassword
                                    ? SvgPicture.asset(
                                        'assets/icons/icon_eye_disabled.svg',
                                        width: 24,
                                        height: 24,
                                      )
                                    : Icon(Icons.visibility_outlined),
                                onPressed: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFieldInput(
                              key: _newConfirmationPasswordKey,
                              obscureText: _obscureConfirmationPassword,
                              labelText: 'Confirm new password',
                              controller: _newConfirmationPasswordController,
                              validator: (value) => Validator.confirmPassword(
                                value,
                                _newPasswordController.text,
                              ),
                              requiredInput: true,
                              suffixIcon: IconButton(
                                focusColor: transparentColor,
                                highlightColor: transparentColor,
                                hoverColor: transparentColor,
                                icon: _obscureConfirmationPassword
                                    ? SvgPicture.asset(
                                        'assets/icons/icon_eye_disabled.svg',
                                        width: 24,
                                        height: 24,
                                      )
                                    : Icon(Icons.visibility_outlined),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmationPassword =
                                        !_obscureConfirmationPassword;
                                  });
                                },
                              ),
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
                      onPressed: _resetPassword,
                      label: 'Submit',
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
