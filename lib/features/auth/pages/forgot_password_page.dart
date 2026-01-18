import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/utils/validator.dart';
import 'package:yb_fe_take_home_test/shared/widgets/button/app_button.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<TextFieldInputState> _emailKey =
      GlobalKey<TextFieldInputState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        shadowColor: whiteColor,
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
                      constraints: BoxConstraints(maxWidth: 379),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                'Forgot Password ?',
                                style: mediumBoldTextStyle,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Don’t worry! it happens. Please enter the address associated with your account.',
                              style: mediumTextStyle,
                            ),
                            SizedBox(height: 16),
                            TextFieldInput(
                              key: _emailKey,
                              labelText: 'Email ID / Mobile number',
                              controller: _emailController,
                              validator: (value) => Validator.email(value),
                              requiredInput: true,
                              clearableText: true,
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
                constraints: BoxConstraints(maxWidth: 379),
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
                    constraints: BoxConstraints(maxWidth: 379),
                    child: AppButton(
                      onPressed: () {
                        context.go('/login');
                      },
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
