

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routepractice/features/coin/data/coin_service.dart';
import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:routepractice/features/coin/domain/coin_repository.dart';

final coinRepositoryProvider = Provider<CoinRepository>((ref) {
  return CoinService();
});


final coinNotifierProvider =
    StateNotifierProvider<CoinNotifier, AsyncValue<List<Coin>>>((ref) {
  final repo = ref.watch(coinRepositoryProvider);
  return CoinNotifier(repo)..loadInitial();
});

class CoinNotifier extends StateNotifier<AsyncValue<List<Coin>>> {
  final CoinRepository _repo;
  int _page = 1;
  bool _isLoadingMore = false;

  CoinNotifier(this._repo) : super(const AsyncLoading());

  /// initial
  Future<void> loadInitial() async {
    try {
      final coins = await _repo.getCoins(page: 1, perPage: 30);
      state = AsyncData(coins);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// refresh all coins
  Future<void> refresh() async {
    _page = 1;
    await loadInitial();
  }

  /// + 1 page
  Future<void> loadMore() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    try {
      final moreCoins = await _repo.getCoins(page: _page + 1, perPage: 30);
      final current = state.value ?? [];
      state = AsyncData([...current, ...moreCoins]);
      _page++;
    } catch (e, st) {
      state = AsyncError(e, st);
    }

    _isLoadingMore = false;
  }
}