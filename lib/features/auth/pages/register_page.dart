import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/utils/validator.dart';
import 'package:yb_fe_take_home_test/shared/widgets/button/app_button_variant.dart';
import 'package:yb_fe_take_home_test/shared/widgets/checkbox_field_input.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';
import 'package:yb_fe_take_home_test/shared/widgets/button/app_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _emailControl = TextEditingController();
  final TextEditingController _nameControl = TextEditingController();
  final TextEditingController _passwordControl = TextEditingController();
  final TextEditingController _passwordConfirmControl = TextEditingController();

  final GlobalKey<TextFieldInputState> _emailKey =
      GlobalKey<TextFieldInputState>();
  final GlobalKey<TextFieldInputState> _nameKey =
      GlobalKey<TextFieldInputState>();
  final GlobalKey<TextFieldInputState> _passwordKey =
      GlobalKey<TextFieldInputState>();
  final GlobalKey<TextFieldInputState> _passwordConfirmKey =
      GlobalKey<TextFieldInputState>();

  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  bool _rememberMe = false;
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  void _register() async {
    final auth = ref.read(authProvider.notifier);

    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _loading = true;
        });

        await auth.register(
          _emailControl.text.trim(),
          _nameControl.text.trim(),
          _passwordControl.text.trim(),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Register berhasil!')));

        context.go('/login');
      } catch (e) {
        print('[_register]: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
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
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                width: double.infinity,
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 450),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 155,
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Hello',
                                        style: largeBoldTextStyle.copyWith(
                                          color: primaryDefaultColor,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 222,
                                      child: Text(
                                        'Signup to get Started',
                                        style: largeTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0, // posisi atas
                                  right: 0, // posisi kanan
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: greenColor,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ), // setengah ukuran box = bulat
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFieldInput(
                            key: _nameKey,
                            labelText: 'Full Name',
                            controller: _nameControl,
                            validator: (value) => Validator.minLength(value, 2),
                            requiredInput: true,
                            clearableText: true,
                          ),
                          const SizedBox(height: 12),
                          TextFieldInput(
                            key: _emailKey,
                            labelText: 'Email',
                            controller: _emailControl,
                            validator: (value) => Validator.email(value),
                            requiredInput: true,
                            clearableText: true,
                          ),
                          const SizedBox(height: 16),
                          TextFieldInput(
                            key: _passwordKey,
                            labelText: 'Password',
                            controller: _passwordControl,
                            validator: (value) => Validator.password(value),
                            obscureText: _obscurePassword,
                            requiredInput: true,
                            suffixIcon: IconButton(
                              focusColor: transparentColor,
                              highlightColor: transparentColor,
                              hoverColor: transparentColor,
                              icon: _obscurePassword
                                  ? SvgPicture.asset(
                                      'assets/icons/icon_eye_disabled.svg',
                                      width: 24,
                                      height: 24,
                                    )
                                  : Icon(Icons.visibility_outlined),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFieldInput(
                            key: _passwordConfirmKey,
                            labelText: 'Password Confirmation',
                            controller: _passwordConfirmControl,
                            validator: (value) => Validator.confirmPassword(
                              value,
                              _passwordControl.text,
                            ),
                            obscureText: _obscurePasswordConfirm,
                            requiredInput: true,
                            suffixIcon: IconButton(
                              focusColor: transparentColor,
                              highlightColor: transparentColor,
                              hoverColor: transparentColor,
                              icon: _obscurePasswordConfirm
                                  ? SvgPicture.asset(
                                      'assets/icons/icon_eye_disabled.svg',
                                      width: 24,
                                      height: 24,
                                    )
                                  : Icon(Icons.visibility_outlined),
                              onPressed: () {
                                setState(() {
                                  _obscurePasswordConfirm =
                                      !_obscurePasswordConfirm;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CheckboxFieldInput(
                                    value: _rememberMe,
                                    labelText: 'Remember me',
                                    onChanged: (v) {
                                      setState(() {
                                        _rememberMe = v;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            label: 'Register',
                            variant: AppButtonVariant.primary,
                            onPressed: _register,
                            isLoading: _loading,
                          ),
                          const SizedBox(height: 16),
                          Text('or continue with'),
                          const SizedBox(height: 16),
                          AppButton(
                            label: 'Google',
                            width: 174,
                            variant: AppButtonVariant.secondary,
                            isLoading: _loading,
                            leadingIcon: Image.asset(
                              'assets/icons/icon_google_auth.png',
                              width: 24,
                              height: 24,
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account ? '),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  onTap: () {
                                    context.go('/login');
                                  },
                                  child: Text(
                                    'Login',
                                    style: linkXSmallTextStyle.copyWith(
                                      color: primaryDefaultColor,
                                    ),
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
