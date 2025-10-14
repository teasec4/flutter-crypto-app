import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/core/widgets/custom_nav_bar.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navShell;
  const AppScaffold({super.key, required this.navShell});

  static const titles = ['Coins', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      extendBodyBehindAppBar: true,
      extendBody: true, //
      appBar: AppBar(
        title: Text(titles[navShell.currentIndex]),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          navShell, // main content
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CustomNavBar(navShell: navShell),
            ),
          ),
        ],
      ),
    );
  }
}