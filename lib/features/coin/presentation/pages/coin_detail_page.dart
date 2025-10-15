import 'package:flutter/material.dart';
import 'package:routepractice/features/coin/presentation/widgets/coin_tile.dart';
import '../../domain/coin.dart';

class CoinDetailPage extends StatelessWidget {
  final Coin coin;
  const CoinDetailPage({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(coin.name),
      ),
      body: Container(
          child:CoinTile(coin: coin),
      ),
    );
  }
}
