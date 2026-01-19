import 'package:flutter/material.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      surfaceTintColor: whiteColor,
      shadowColor: whiteColor,
      elevation: 0,
      title: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Row(
            children: [
              InkWell(
                focusColor: transparentColor,
                splashColor: transparentColor,
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                onTap: () {
                  context.go('/login');
                },
                child: const Icon(Icons.arrow_back),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
