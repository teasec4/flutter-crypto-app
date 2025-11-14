import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepractice/core/utils/retry_strategy.dart';
import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:routepractice/features/coin/domain/coin_repository.dart';

part 'coin_event.dart';
part 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final CoinRepository _repo;
  final RetryStrategy _retryStrategy;
  int _page = 1;

  CoinBloc(this._repo, this._retryStrategy) : super(const CoinInitial()) {
    on<CoinInitialLoad>(_onInitialLoad);
    on<CoinLoadMore>(_onLoadMore);
    on<CoinRefresh>(_onRefresh);
  }

  /// Load initial coins list
  Future<void> _onInitialLoad(CoinInitialLoad event, Emitter<CoinState> emit) async {
    emit(const CoinLoading());
    try {
      final coins = await _retryStrategy.execute(
        () => _repo.getCoins(page: 1, perPage: 30),
      );
      _page = 1;
      emit(CoinLoaded(coins: coins));
    } catch (e) {
      emit(CoinError(e.toString()));
    }
  }

  /// Load next page
  Future<void> _onLoadMore(CoinLoadMore event, Emitter<CoinState> emit) async {
    if (state is! CoinLoaded) return;

    final currentState = state as CoinLoaded;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final moreCoins = await _retryStrategy.execute(
        () => _repo.getCoins(page: _page + 1, perPage: 30),
      );
      _page++;
      final allCoins = [...currentState.coins, ...moreCoins];
      emit(CoinLoaded(coins: allCoins));
    } catch (e) {
      emit(CoinError(e.toString()));
    }
  }

  /// Refresh all coins
  Future<void> _onRefresh(CoinRefresh event, Emitter<CoinState> emit) async {
    await _onInitialLoad(const CoinInitialLoad(), emit);
  }

  bool get isLoadingMore => state is CoinLoaded && (state as CoinLoaded).isLoadingMore;
}
