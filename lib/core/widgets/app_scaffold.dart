import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/core/widgets/custom_nav_bar.dart';
import 'package:routepractice/features/coin/domain/coin.dart';

class AppScaffold extends ConsumerWidget {
  final StatefulNavigationShell navShell;
  const AppScaffold({super.key, required this.navShell});

  static const titles = ['Coins', 'Profile'];

  bool _isDetailRoute(String location) {
    return location.contains('/coins/');
  }


  String _getDetailTitle(BuildContext context, String location) {
    final state = GoRouterState.of(context);
    final extra = state.extra;

    if (extra is Coin) {
      return extra.name;
    }

    return 'Details';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final isDetailPage = _isDetailRoute(location);
    final detailTitle = isDetailPage ? _getDetailTitle(context, location) : null;

    List<Widget>? actions;

    return Scaffold(
      backgroundColor: AppPalette.background,
      extendBodyBehindAppBar: true,
      extendBody: true, //
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: isDetailPage
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              )
            : null,
        title: Text(
          isDetailPage ? (detailTitle ?? 'Details') : titles[navShell.currentIndex],
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: actions,
      ),
      body: Stack(
        children: [
          navShell, // main content
          if (!isDetailPage) // Only show bottom nav on main pages
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