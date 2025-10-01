import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/coin.dart';

class RowCoinView extends StatelessWidget {
  final Coin coin;
  final bool isFavorite;

  const RowCoinView({super.key,
    required this.coin,
    required this.isFavorite,});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(coin.imageUrl),
          backgroundColor: Colors.transparent,
        ),
        title: Text(coin.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(coin.symbol.toUpperCase()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
                Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.amber : Colors.grey,
          ),
          const SizedBox(width: 8),
            Text(
              "\$${coin.price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 16,
              ),
            ),
          ],
        ),
        onTap: () {
          context.push(
            '/coins/${coin.id}', // путь нужен, чтобы GoRouter сматчил маршрут
            extra: coin,         // 👈 сюда передаём объект Coin
          );
        },
      ),
    );
  }
}