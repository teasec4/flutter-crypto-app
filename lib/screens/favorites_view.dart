import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/viewmodels/coin_view_model.dart';
import '../viewmodels/user_view_model.dart';
import '../widgets/row_coin_view.dart';
import '../models/coin.dart';

class FavoritesView extends ConsumerWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsAsync = ref.watch(coinsProvider);
    final userAsync = ref.watch(userProvider);

    return Stack(
      children: [
        userAsync.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text("No user logged in"));
            }

            // ⚡ берём избранные монеты по id
            final coinsBox = ref.read(userProvider.notifier).coinsBox; 
            final favorites = user.favoriteIds
                .map((id) => coinsBox.get(id))
                .whereType<Coin>()
                .toList();

            if (favorites.isEmpty) {
              return const Center(child: Text("No favorites yet"));
            }

            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(coinsProvider),
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final coin = favorites[index];
                  final isFav = user.favoriteIds.contains(coin.id);
                  return RowCoinView(coin: coin, isFavorite: isFav);
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
        ),

        // 🔹 Индикатор обновления сверху
        if (coinsAsync.isRefreshing)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}