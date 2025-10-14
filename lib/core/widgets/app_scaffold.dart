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
      appBar:  AppBar(title: Text(titles[navShell.currentIndex]),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: navShell,
      extendBody: true,
      bottomNavigationBar: CustomNavBar(navShell: navShell),
    );
  }

}