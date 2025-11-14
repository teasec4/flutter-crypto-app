part of 'coin_bloc.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object> get props => [];
}

class CoinInitialLoad extends CoinEvent {
  const CoinInitialLoad();
}

class CoinLoadMore extends CoinEvent {
  const CoinLoadMore();
}

class CoinRefresh extends CoinEvent {
  const CoinRefresh();
}
