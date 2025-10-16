import 'package:flutter/material.dart';
import 'package:routepractice/features/coin/presentation/widgets/coin_tile.dart';
import '../../domain/coin.dart';

class CoinDetailPage extends StatelessWidget {
  final Coin coin;
  const CoinDetailPage({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: CoinTile(coin: coin),
      ),
    );
  }
}
