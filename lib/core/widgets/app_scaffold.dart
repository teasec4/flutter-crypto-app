import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/core/widgets/custom_nav_bar.dart';
import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:routepractice/features/favorites/domain/favorite_item.dart';
import 'package:routepractice/features/favorites/presentation/favorites_view_model.dart';
import 'package:routepractice/features/nft/domain/nft.dart';

class AppScaffold extends ConsumerWidget {
  final StatefulNavigationShell navShell;
  const AppScaffold({super.key, required this.navShell});

  static const titles = ['Coins', 'NFT', 'Favorites', 'Profile'];

  bool _isDetailRoute(String location) {
    return location.contains('/coins/') || location.contains('/nfts/');
  }


  String _getDetailTitle(BuildContext context, String location) {

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
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final isDetailPage = _isDetailRoute(location);
    final detailTitle = isDetailPage ? _getDetailTitle(context, location) : null;
    final state = GoRouterState.of(context);
    final extra = state.extra;

    List<Widget>? actions;
    if (isDetailPage) {
      if (extra is Coin) {
        final isFavorite = ref.watch(isFavoriteProvider((id: extra.id, type: FavoriteType.coin)));
        actions = [
          IconButton(
            onPressed: () async {
              final notifier = ref.read(favoritesNotifierProvider.notifier);
              if (isFavorite) {
                await notifier.removeFavorite(extra.id, FavoriteType.coin);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ ${extra.name} removed from favorites'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                await notifier.addFavorite(FavoriteItem.fromCoin(extra));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❤️ ${extra.name} added to favorites'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              }
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
              size: 28,
            ),
          ),
        ];
      } else if (extra is NFT) {
        final favoriteId = extra.contractAddress.isNotEmpty ? extra.contractAddress : extra.id;
        final isFavorite = ref.watch(isFavoriteProvider((id: favoriteId, type: FavoriteType.nft)));
        actions = [
          IconButton(
            onPressed: () async {
              final notifier = ref.read(favoritesNotifierProvider.notifier);
              if (isFavorite) {
                await notifier.removeFavorite(favoriteId, FavoriteType.nft);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ ${extra.name} removed from favorites'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                await notifier.addFavorite(FavoriteItem.fromNFT(extra));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❤️ ${extra.name} added to favorites'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              }
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
              size: 28,
            ),
          ),
        ];
      }
    }

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