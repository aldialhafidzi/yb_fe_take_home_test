import 'package:flutter/material.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/utils/validator.dart';
import 'package:yb_fe_take_home_test/shared/widgets/button/app_button_variant.dart';
import 'package:yb_fe_take_home_test/shared/widgets/checkbox_field_input.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';
import 'package:yb_fe_take_home_test/shared/widgets/button/app_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_fe_take_home_test/core/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<TextFieldInputState> _emailKey =
      GlobalKey<TextFieldInputState>();
  final GlobalKey<TextFieldInputState> _passwordKey =
      GlobalKey<TextFieldInputState>();

  bool _obscure = true;
  bool _rememberMe = false;
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      final auth = ref.read(authProvider.notifier);

      try {
        await auth.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (!mounted) return;
        context.go('/home');

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login berhasil!')));
      } catch (e) {
        print('[_login]: $e');

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
  void initState() {
    super.initState();
    ref.read(authProvider.notifier).initState();
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
                            height: 240,
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Hello',
                                        style: largeBoldTextStyle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Again!',
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
                                        'Welcome back you’ve been missed',
                                        style: largeTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: greenColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFieldInput(
                            key: _emailKey,
                            labelText: 'Email',
                            controller: _emailController,
                            validator: (value) => Validator.email(value),
                            requiredInput: true,
                            clearableText: true,
                          ),
                          const SizedBox(height: 16),
                          TextFieldInput(
                            key: _passwordKey,
                            labelText: 'Password',
                            controller: _passwordController,
                            obscureText: _obscure,
                            requiredInput: true,
                            suffixIcon: IconButton(
                              focusColor: transparentColor,
                              highlightColor: transparentColor,
                              hoverColor: transparentColor,
                              icon: _obscure
                                  ? SvgPicture.asset(
                                      'assets/icons/icon_eye_disabled.svg',
                                      width: 24,
                                      height: 24,
                                    )
                                  : Icon(Icons.visibility_outlined),
                              onPressed: () {
                                setState(() {
                                  _obscure = !_obscure;
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
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                onTap: () {
                                  context.go('/forgot-password');
                                },
                                child: Text(
                                  'Forgot the password?',
                                  style: smallTextStyle.copyWith(
                                    color: primaryDarkModeColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            label: 'Login',
                            variant: AppButtonVariant.primary,
                            onPressed: _login,
                            isLoading: _loading,
                          ),
                          const SizedBox(height: 16),
                          Text('or continue with'),
                          const SizedBox(height: 16),
                          AppButton(
                            label: 'Google',
                            width: 174,
                            variant: AppButtonVariant.secondary,
                            leadingIcon: Image.asset(
                              'assets/icons/icon_google_auth.png',
                              width: 24,
                              height: 24,
                            ),
                            onPressed: () {},
                            isLoading: _loading,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('don’t have an account ? '),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  onTap: () {
                                    context.go('/register');
                                  },
                                  child: Text(
                                    'Sign Up',
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
