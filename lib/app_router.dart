import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:routepractice/screens/auth_gate_view.dart';

import 'models/coin.dart';
import 'models/user.dart';
import 'screens/coin_list_view.dart';
import 'screens/favorites_view.dart';
import 'screens/coin_detail_view.dart';

import 'screens/profile_view.dart';

import 'viewmodels/user_view_model.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(userProvider).value; // текущий юзер
  final hasUser = Hive.box<User>('userBox').isNotEmpty;

  return GoRouter(
    initialLocation: '/coins',

    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isAuth = loc == '/auth';

      // ❌ Нет юзера или не залогинен → на /auth
      if (!hasUser || user == null) {
        if (!isAuth) return '/auth';
        return null;
      }

      // ✅ Уже залогинен → не пускаем на /auth
      if (isAuth) return '/coins';

      return null;
    },

    routes: [
      // --- Auth ---
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthGateView(),
      ),

      // --- Profile ---
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileView(),
      ),

      // --- Основной Shell ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_titleFor(state.matchedLocation)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () => context.push('/profile'),
                ),
              ],
            ),
            body: navShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navShell.currentIndex,
              onDestinationSelected: navShell.goBranch,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.list), label: 'Coins'),
                NavigationDestination(icon: Icon(Icons.star), label: 'Favorites'),
              ],
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/coins',
                builder: (context, state) => const CoinListView(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final extra = state.extra;
                      if (extra is Coin) {
                        return Scaffold(
                          appBar: AppBar(title: Text(extra.name)),
                          body: CoinDetailView(coin: extra),
                        );
                      }
                      return const Scaffold(
                        body: Center(child: Text('No coin data')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const FavoritesView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

String _titleFor(String location) {
  if (location.startsWith('/favorites')) return 'Favorites';
  if (location.startsWith('/coins/'))   return 'Coin Details';
  if (location.startsWith('/coins'))    return 'Coins';
  return '';
}