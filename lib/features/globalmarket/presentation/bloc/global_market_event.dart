part of 'global_market_bloc.dart';

abstract class GlobalMarketEvent extends Equatable {
  const GlobalMarketEvent();

  @override
  List<Object?> get props => [];
}

class GlobalMarketLoadData extends GlobalMarketEvent {
  const GlobalMarketLoadData();
}

class GlobalMarketRefresh extends GlobalMarketEvent {
  const GlobalMarketRefresh();
}
