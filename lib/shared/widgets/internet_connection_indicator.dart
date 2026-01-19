import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';

class InternetConnectionIndicator extends StatelessWidget {
  const InternetConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final results = snapshot.data!;
        final isOffline = results.contains(ConnectivityResult.none);

        if (!isOffline) {
          return const SizedBox();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6),
          color: errorDarkColor,
          child: const Text(
            'No Internet Connection',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      },
    );
  }
}
