import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/widgets/app_scaffold.dart';
import 'package:routepractice/features/auth/presentation/pages/login_page.dart';
import 'package:routepractice/features/auth/presentation/pages/signup_page.dart';
import 'package:routepractice/features/auth/presentation/pages/splash_page.dart';
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
    initialLocation: '/splash',
    refreshListenable: notifier,

    // Authentication redirect logic
    redirect: (context, state) {
      final isLoading = notifier.isLoading;
      final isAuthenticated = notifier.isAuthenticated;
      final isSplash = state.matchedLocation == '/splash';
      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      // Show splash while loading auth state
      if (isLoading && !isSplash) {
        return '/splash';
      }

      // If loading and on splash, stay on splash
      if (isLoading && isSplash) {
        return null;
      }

      // If not authenticated and not on auth routes, redirect to login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // If authenticated and on auth routes or splash, redirect to coins
      if (isAuthenticated && (isAuthRoute || isSplash)) {
        return '/coins';
      }

      // No redirect needed
      return null;
    },

    routes: [
      // === SPLASH ROUTE ===
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),

      // === AUTH ROUTES ===
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
                    pageBuilder: (context, state) {
                      final coin = state.extra as Coin;
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: CoinDetailPage(coin: coin),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      );
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
                    pageBuilder: (context, state) {
                      final nftId = state.pathParameters['id']!;
                      final nft = state.extra as NFT?;
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: NFTDetailPage(nftId: nftId, nft: nft),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      );
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
