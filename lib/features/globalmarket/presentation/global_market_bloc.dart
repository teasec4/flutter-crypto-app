import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepractice/core/logger/logger.dart';
import 'package:routepractice/features/globalmarket/domain/coin_market.dart';
import 'package:routepractice/features/globalmarket/domain/global_market_repository.dart';

part 'global_market_event.dart';
part 'global_market_state.dart';

class GlobalMarketBloc extends Bloc<GlobalMarketEvent, GlobalMarketState> {
  final GlobalMarketRepository _repo;
  final Logger _logger;

  GlobalMarketBloc(this._repo, this._logger)
      : super(const GlobalMarketInitial()) {
    on<GlobalMarketLoadData>(_onLoadData);
    on<GlobalMarketRefresh>(_onRefresh);
  }

  Future<void> _onLoadData(
    GlobalMarketLoadData event,
    Emitter<GlobalMarketState> emit,
  ) async {
    _logger.info('GlobalMarketBloc.loadData() START');
    emit(const GlobalMarketLoading());
    try {
      final data = await _repo.getGlobalMarketData();
      _logger.info('Global data fetched successfully!');
      emit(GlobalMarketLoaded(data));
    } catch (e, st) {
      _logger.error('GlobalMarketBloc error: $e', st);
      emit(GlobalMarketError(e.toString()));
    }
  }

  Future<void> _onRefresh(
    GlobalMarketRefresh event,
    Emitter<GlobalMarketState> emit,
  ) async {
    await _onLoadData(const GlobalMarketLoadData(), emit);
  }
}
