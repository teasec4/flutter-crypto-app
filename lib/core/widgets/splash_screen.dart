import 'package:flutter/material.dart';
import 'package:routepractice/core/theme/app_palete.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      body: const Center(
        child: CircularProgressIndicator(color: AppPalette.accent),
      ),
    );
  }
}