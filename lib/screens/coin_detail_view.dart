import 'package:flutter/material.dart';
import '../models/coin.dart';

class CoinDetailView extends StatelessWidget {
  final Coin coin;

  const CoinDetailView({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(coin.imageUrl, width: 64, height: 64),
            const SizedBox(height: 16),
            Text(
              coin.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              coin.symbol.toUpperCase(),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              "\$${coin.price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      );
    
  }
}