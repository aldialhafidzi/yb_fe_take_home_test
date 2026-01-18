import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/providers/auth_provider.dart';
import 'package:yb_fe_take_home_test/features/auth/pages/login_page.dart';
import 'package:yb_fe_take_home_test/features/auth/pages/register_page.dart';
import 'package:yb_fe_take_home_test/features/home/pages/home_page.dart';
import 'package:yb_fe_take_home_test/features/auth/pages/forgot_password_page.dart';
import 'package:yb_fe_take_home_test/features/auth/pages/reset_password_page.dart';
import 'package:yb_fe_take_home_test/features/auth/pages/otp_verification_page.dart';
import 'package:yb_fe_take_home_test/features/bookmark/pages/bookmark_page.dart';
import 'package:yb_fe_take_home_test/features/home/pages/category_page.dart';
import 'package:yb_fe_take_home_test/features/home/pages/detail_page.dart';
import 'package:yb_fe_take_home_test/features/profile/pages/profile_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: auth, // listen ke auth state
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = auth.isLoggedIn;
      final loggedOTP = auth.isLoggedOTP;
      final authRoutes = [
        '/login',
        '/register',
        '/forgot-password',
        '/reset-password',
      ];

      final loggingIn = authRoutes.contains(state.matchedLocation);

      // jika belum login tapi bukan login/register, redirect ke login
      if (!loggedIn && !loggingIn) return '/login';

      // jika sudah login tapi berada di login/register, redirect ke home
      if (loggedIn && loggingIn && !loggedOTP) return '/otp-verification';
      if (loggedIn && loggingIn && loggedOTP) return '/home';

      return null; // tidak ada redirect
    },

    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) => const OTPVerificationPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/bookmark',
        builder: (context, state) => const BookmarkPage(),
      ),
      GoRoute(
        path: '/articles/:category',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          return CategoryPage(category: category);
        },
      ),
      GoRoute(
        path: '/articles/detail/:title',
        builder: (context, state) {
          final title = state.pathParameters['title']!;
          return DetailPage(title: title);
        },
      ),
    ],
  );
});
