import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/widgets/app_scaffold.dart';
import 'package:routepractice/features/auth/presentation/pages/auth_gate.dart';
import 'package:routepractice/features/auth/presentation/pages/login_page.dart';
import 'package:routepractice/features/auth/presentation/pages/signup_page.dart';
import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:routepractice/features/coin/presentation/pages/coin_detail_page.dart';
import 'package:routepractice/features/coin/presentation/pages/coin_page.dart';
import 'package:routepractice/features/profile/presentation/pages/profile_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',


    routes: [
      GoRoute(path: '/', builder: (_, __) => const AuthGate()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      GoRoute(
        path: '/coins/:id',

        builder: (context, state) {
          final coin = state.extra as Coin;
          return CoinDetailPage(coin: coin);
        },
      ),
      // --- Main Shell ---
      StatefulShellRoute.indexedStack(

        builder: (context, state, navShell) => AppScaffold(navShell: navShell),
        branches: [
          StatefulShellBranch(

            routes: [
              GoRoute(
                path: '/coins',
                builder: (context, state) => const CoinPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (c, s) => const CoinPage(),
                  ),
                ]
              ),
            ],
          ),
          
          // Profile
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
