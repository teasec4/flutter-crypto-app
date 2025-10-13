import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/widgets/app_scaffold.dart';
import 'package:routepractice/features/auth/presentation/pages/login_page.dart';
import 'package:routepractice/features/auth/presentation/pages/signup_page.dart';

import 'package:routepractice/features/coin/presentation/pages/coin_page.dart';
import 'package:routepractice/features/profile/presentation/pages/profile_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',

    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      // --- Main Shell ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) => AppScaffold(navShell: navShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/coins',
                builder: (context, state) => const CoinPage(),
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
