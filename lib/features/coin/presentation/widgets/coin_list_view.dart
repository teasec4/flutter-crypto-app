import 'package:flutter/material.dart';
import 'package:routepractice/features/coin/presentation/widgets/coin_tile.dart';
import '../../domain/coin.dart';


class CoinListView extends StatelessWidget {
  final List<Coin> coins;

  const CoinListView({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: coins.length,
      itemBuilder: (_, i) => CoinTile(coin: coins[i]), 
    );
  }
}