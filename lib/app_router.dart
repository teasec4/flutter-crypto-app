import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/widgets/app_scaffold.dart';
import 'package:routepractice/features/auth/presentation/pages/auth_gate.dart';
import 'package:routepractice/features/auth/presentation/pages/login_page.dart';
import 'package:routepractice/features/auth/presentation/pages/signup_page.dart';
import 'package:routepractice/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:routepractice/features/coin/presentation/pages/coin_detail_page.dart';
import 'package:routepractice/features/coin/presentation/pages/coin_page.dart';
import 'package:routepractice/features/favorites/presentation/pages/favorites_page.dart';
import 'package:routepractice/features/nft/domain/nft.dart';
import 'package:routepractice/features/nft/presentation/pages/nft_detail_page.dart';
import 'package:routepractice/features/nft/presentation/pages/nft_page.dart';
import 'package:routepractice/features/profile/presentation/pages/profile_page.dart';
import 'package:routepractice/go_router_notifier.dart';

/// Root navigator key for the app
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Main app router provider with authentication redirects
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(goRouterNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: notifier,

    // Authentication redirect logic
    redirect: (context, state) {
      final isAuth = notifier.isAuthenticated;
      final goingToAuth =
          state.matchedLocation == '/' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isAuth && !goingToAuth) {
        return '/login';
      }
      if (isAuth && goingToAuth) {
        return '/coins';
      }
      return null;
    },

    routes: [
      // === AUTH ROUTES (Outside Shell) ===
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),

      // === MAIN SHELL WITH BOTTOM NAVIGATION ===
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppScaffold(navShell: navigationShell),

        branches: [
          // === COINS BRANCH ===
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/coins',
                builder: (context, state) => const CoinPage(),
                routes: [
                  GoRoute(
                    path: 'details/:id',
                    builder: (context, state) {
                      final coin = state.extra as Coin;
                      return CoinDetailPage(coin: coin);
                    },
                  ),
                ],
              ),
            ],
          ),

          // === NFTS BRANCH ===
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/nfts',
                builder: (context, state) => const NFTPage(),
                routes: [
                  GoRoute(
                    path: 'details/:id',
                    builder: (context, state) {
                      final nftId = state.pathParameters['id']!;
                      final nft = state.extra as NFT?;
                      return NFTDetailPage(nftId: nftId, nft: nft);
                    },
                  ),
                                  ],
              ),
            ],
          ),

          // === FAVORITES BRANCH ===
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),

          // === PROFILE BRANCH ===
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
