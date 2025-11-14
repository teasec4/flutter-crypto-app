import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/di/service_locator.dart';
import 'package:routepractice/core/widgets/app_scaffold.dart';
import 'package:routepractice/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:routepractice/features/auth/presentation/pages/login_page.dart';
import 'package:routepractice/features/auth/presentation/pages/signup_page.dart';
import 'package:routepractice/features/auth/presentation/pages/splash_page.dart';
import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:routepractice/features/coin/presentation/pages/coin_detail_page.dart';
import 'package:routepractice/features/coin/presentation/pages/coin_page.dart';
import 'package:routepractice/features/profile/presentation/pages/profile_page.dart';

/// Root navigator key for the app
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Main app router with authentication redirects
late final GoRouter appRouter;

/// Initialize app router
/// Must be called after AuthCubit is created and during app initialization
void initializeRouter() {
  appRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final authCubit = getIt<AuthCubit>();
      final authState = authCubit.state;
      
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoading = authState is AuthLoading;
      
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
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),

      // === AUTH ROUTES ===
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),

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
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: CoinDetailPage(coin: coin),
                      );
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
}
