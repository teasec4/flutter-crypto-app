part of 'coin_bloc.dart';

abstract class CoinState extends Equatable {
  const CoinState();

  @override
  List<Object> get props => [];
}

class CoinInitial extends CoinState {
  const CoinInitial();
}

class CoinLoading extends CoinState {
  const CoinLoading();
}

class CoinLoaded extends CoinState {
  final List<Coin> coins;
  final bool isLoadingMore;

  const CoinLoaded({
    required this.coins,
    this.isLoadingMore = false,
  });

  @override
  List<Object> get props => [coins, isLoadingMore];

  CoinLoaded copyWith({
    List<Coin>? coins,
    bool? isLoadingMore,
  }) {
    return CoinLoaded(
      coins: coins ?? this.coins,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CoinError extends CoinState {
  final String message;
  const CoinError(this.message);

  @override
  List<Object> get props => [message];
}
