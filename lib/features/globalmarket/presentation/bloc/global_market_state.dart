part of 'global_market_bloc.dart';

abstract class GlobalMarketState extends Equatable {
  const GlobalMarketState();

  @override
  List<Object?> get props => [];
}

class GlobalMarketInitial extends GlobalMarketState {
  const GlobalMarketInitial();
}

class GlobalMarketLoading extends GlobalMarketState {
  const GlobalMarketLoading();
}

class GlobalMarketLoaded extends GlobalMarketState {
  final GlobalMarketData data;

  const GlobalMarketLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class GlobalMarketError extends GlobalMarketState {
  final String message;

  const GlobalMarketError(this.message);

  @override
  List<Object?> get props => [message];
}
