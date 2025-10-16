import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/core/widgets/custom_nav_bar.dart';
import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:routepractice/features/nft/domain/nft.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navShell;
  const AppScaffold({super.key, required this.navShell});

  static const titles = ['Coins', 'NFT', 'Favorites', 'Profile'];

  bool _isDetailRoute(String location) {
    return location.contains('/coins/') || location.contains('/nfts/');
  }


  String _getDetailTitle(BuildContext context, String location) {
    // Пытаемся достать объект, переданный через extra
    final state = GoRouterState.of(context);
    final extra = state.extra;

    if (location.contains('/coins/') && extra is Coin) {
      return (extra as Coin).name;
    }
    if (location.contains('/nfts/') && extra is NFT) {
      return (extra as NFT).name;
    }

    return 'Details';
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final isDetailPage = _isDetailRoute(location);
    final detailTitle = isDetailPage ? _getDetailTitle(context, location) : null;

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