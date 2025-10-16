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
import 'package:routepractice/features/nft/presentation/pages/nft_detail_page.dart';
import 'package:routepractice/features/nft/presentation/pages/nft_page.dart';
import 'package:routepractice/features/profile/presentation/pages/profile_page.dart';

/// Root navigator key for the app
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Main app router provider with authentication redirects
final appRouterProvider = Provider<GoRouter>((ref) {
  final authViewModel = ref.watch(authViewModelProvider.notifier);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',

    // Authentication redirect logic
    redirect: (context, state) {
      final isAuthenticated = authViewModel.isAuthenticated;
      final isGoingToAuth = state.matchedLocation == '/' ||
                           state.matchedLocation == '/login' ||
                           state.matchedLocation == '/signup';

      // If not authenticated and not on auth route, redirect to login
      if (!isAuthenticated && !isGoingToAuth) {
        return '/login';
      }

      // If authenticated and on auth route, redirect to main app
      if (isAuthenticated && isGoingToAuth) {
        return '/coins';
      }

      // No redirect needed
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
                      return NFTDetailPage(nftId: nftId);
                    },
                  ),
                ],
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
