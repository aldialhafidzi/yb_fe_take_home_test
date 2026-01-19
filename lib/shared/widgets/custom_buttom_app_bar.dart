import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';

Widget buildMenuItem(
  IconData icon,
  String label,
  String url,
  BuildContext context,
) {
  return InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    onTap: () {
      context.go(url);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24),
        SizedBox(height: 4),
        Text(label, style: smallTextStyle),
      ],
    ),
  );
}

class CustomButtomAppBar extends StatelessWidget {
  const CustomButtomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      surfaceTintColor: whiteColor,
      color: whiteColor,
      padding: EdgeInsets.all(0),
      child: Center(
        child: Container(
          height: 76,
          constraints: BoxConstraints(maxWidth: 450),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 2, color: greenColor)),
          ),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 450),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // <--- penting
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildMenuItem(Icons.home_outlined, 'Home', '/home', context),
                  buildMenuItem(
                    Icons.explore_outlined,
                    'Explore',
                    '/articles/general',
                    context,
                  ),
                  buildMenuItem(
                    Icons.bookmark_outline,
                    'Bookmark',
                    '/bookmark',
                    context,
                  ),
                  buildMenuItem(
                    Icons.account_circle_outlined,
                    'Profile',
                    '/profile',
                    context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
