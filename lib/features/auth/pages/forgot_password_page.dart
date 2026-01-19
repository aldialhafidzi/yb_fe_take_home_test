import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/utils/validator.dart';
import 'package:yb_fe_take_home_test/shared/widgets/button/app_button.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';
import 'package:yb_fe_take_home_test/core/providers/auth_provider.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<TextFieldInputState> _emailKey = GlobalKey<TextFieldInputState>();

  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      final auth = ref.read(authProvider.notifier);

      try {
        int resCode = await auth.forgotPassword(_emailController.text.trim());

        if (!mounted) return;
        if (resCode == 999) throw Exception();

        context.go('/reset-password');
      } catch (e) {
        print('error: $e');

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Email tidak ditemukan!')));
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

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
                      constraints: BoxConstraints(maxWidth: 450),
                      child: Form(
                        key: _formKey,
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
