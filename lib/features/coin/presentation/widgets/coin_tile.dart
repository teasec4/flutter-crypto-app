import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/coin.dart';

class CoinTile extends StatelessWidget {
  final Coin coin;

  const CoinTile({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push('/coins/${coin.id}', extra: coin),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(coin.marketCap),
          const SizedBox(width: 8,),
          Image.network(coin.imageUrl, width: 36),
        ],
      ),
      title: Text(
        coin.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        coin.symbol.toUpperCase(),
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$${coin.price.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${coin.priceChangePercentage24H.toStringAsFixed(2)}%',
            style: TextStyle(
              color: coin.priceChangePercentage24H >= 0
                  ? Colors.green
                  : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}