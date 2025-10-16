import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/favorites/domain/favorite_item.dart';
import 'package:routepractice/features/favorites/presentation/favorites_view_model.dart';
import 'package:routepractice/features/nft/domain/nft.dart';

class NFTItem extends ConsumerWidget {
  final NFT nft;
  final VoidCallback? onToggleFavorite;

  const NFTItem({
    super.key,
    required this.nft,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteId =
        nft.contractAddress.isNotEmpty ? nft.contractAddress : nft.id;
    final isFavorite = ref.watch(
      isFavoriteProvider((id: favoriteId, type: FavoriteType.nft)),
    );

    return _buildTile(context, isFavorite);
  }

  Widget _buildTile(BuildContext context, bool isFavorite) {
    return Stack(
      children: [
        // --- основная карточка ---
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: AppPalette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => _navigateToDetail(context),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- NFT изображение ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: nft.imageUrl != null
                        ? Image.network(
                            nft.imageUrl!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                  ),

                  const SizedBox(width: 16),

                  // --- NFT информация ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nft.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${nft.symbol.toUpperCase()} • ${nft.assetPlatformId}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                        if (nft.floorPrice != null &&
                            nft.floorPriceCurrency != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Floor: ${nft.floorPrice!.toStringAsFixed(4)} ${nft.floorPriceCurrency}',
                            style: TextStyle(
                              color: AppPalette.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),

                        // --- кнопка View Details ---
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () => _navigateToDetail(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppPalette.accent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppPalette.accent.withOpacity(0.4),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // --- сердечко (избранное) ---
        Positioned(
          right: 16,
          top: 14,
          child: GestureDetector(
            onTap: () => onToggleFavorite?.call(),
            behavior: HitTestBehavior.translucent,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: child,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(isFavorite),
                color: isFavorite ? Colors.redAccent : Colors.white70,
                size: 26,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() => Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: AppPalette.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.white54,
          size: 24,
        ),
      );

  void _navigateToDetail(BuildContext context) {
    final detailId =
        nft.contractAddress.isNotEmpty ? nft.contractAddress : nft.id;
    context.push('/nfts/details/$detailId', extra: nft);
  }
}