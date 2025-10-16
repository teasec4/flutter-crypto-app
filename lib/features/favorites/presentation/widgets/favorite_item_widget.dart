import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/favorites/domain/favorite_item.dart';

class FavoriteItemWidget extends StatelessWidget {
  final FavoriteItem favorite;
  final VoidCallback onRemove;

  const FavoriteItemWidget({
    super.key,
    required this.favorite,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onRemove(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Remove',
            ),
          ],
        ),
        child: InkWell(
          onTap: () => _navigateToDetail(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Image
                if (favorite.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      favorite.imageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppPalette.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          favorite.type == FavoriteType.coin
                              ? Icons.currency_bitcoin
                              : Icons.collections,
                          color: Colors.white54,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppPalette.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      favorite.type == FavoriteType.coin
                          ? Icons.currency_bitcoin
                          : Icons.collections,
                      color: Colors.white54,
                      size: 24,
                    ),
                  ),

                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favorite.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${favorite.symbol.toUpperCase()} • ${favorite.type == FavoriteType.coin ? 'Coin' : 'NFT'}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    if (favorite.type == FavoriteType.coin) {
      // Navigate to coin detail
      try {
        final coin = favorite.toCoin();
        context.push('/coins/details/${coin.id}', extra: coin);
      } catch (e) {
        // Fallback if coin parsing fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to navigate to coin details')),
        );
      }
    } else {
      // Navigate to NFT detail
      context.push('/nfts/details/${favorite.id}');
    }
  }
}
