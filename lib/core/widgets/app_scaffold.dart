import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navShell;
  const AppScaffold({super.key, required this.navShell});

  static const titles = ['Coins', 'Profile'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text(titles[navShell.currentIndex])),
      body: navShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navShell.currentIndex,
        onDestinationSelected: navShell.goBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Coins'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

}