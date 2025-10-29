import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/features/favorites/domain/favorite_item.dart';
import 'package:routepractice/features/favorites/presentation/favorites_view_model.dart';
import '../../domain/coin.dart';

class CoinTile extends ConsumerWidget {
  final Coin coin;
  const CoinTile({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider((id: coin.id, type: FavoriteType.coin)));

    return Slidable(
      key: ValueKey(coin.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) async {
              final notifier = ref.read(favoritesNotifierProvider.notifier);
              if (isFavorite) {
                await notifier.removeFavorite(coin.id, FavoriteType.coin);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ ${coin.name} removed from favorites'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                await notifier.addFavorite(FavoriteItem.fromCoin(coin));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❤️ ${coin.name} added to favorites'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              }
            },
            backgroundColor: isFavorite ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
            label: isFavorite ? 'Remove' : 'Add',
          ),
        ],
      ),

      child: ListTile(
        onTap: () => context.push('/coins/details/${coin.id}', extra: coin),
        dense: true, // <-- делает элемент компактнее
        visualDensity: VisualDensity.compact, // <-- уменьшает отступы ещё сильнее
        splashColor: Colors.transparent,   // убирает “всплеск” (волну)
        hoverColor: Colors.transparent,     // убирает подсветку при наведении (для Web)
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              coin.marketCap,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Image.network(
              coin.imageUrl,
              width: 20,
              height: 20,
              errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 20),
            ),
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
      ),
    );
  }
}