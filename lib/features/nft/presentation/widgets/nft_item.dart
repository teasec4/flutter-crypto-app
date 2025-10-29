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

    const imageSize = 100.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppPalette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: nft.imageUrl != null
                    ? Image.network(
                  nft.imageUrl!,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imagePlaceholder(size: imageSize),
                )
                    : _imagePlaceholder(size: imageSize),
              ),

              const SizedBox(width: 16),


              Expanded(
                child: SizedBox(
                  height: imageSize,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔝 Название + ❤️
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              nft.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => onToggleFavorite?.call(),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                key: ValueKey(isFavorite),
                                color: isFavorite
                                    ? Colors.redAccent
                                    : Colors.white70,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 🔸 Символ и платформа
                      Text(
                        '${nft.symbol.toUpperCase()} • ${nft.assetPlatformId}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      // 💰 Floor price (если есть)
                      if (nft.floorPrice != null &&
                          nft.floorPriceCurrency != null)
                        Text(
                          'Floor: ${nft.floorPrice!.toStringAsFixed(4)} ${nft.floorPriceCurrency}',
                          style: TextStyle(
                            color: AppPalette.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      // 🔘 View Details кнопка — прижата к низу карточки
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () => _navigateToDetail(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder({double size = 100}) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: AppPalette.surface,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(
      Icons.image_not_supported,
      color: Colors.white54,
      size: 28,
    ),
  );

  void _navigateToDetail(BuildContext context) {
    final detailId =
    nft.contractAddress.isNotEmpty ? nft.contractAddress : nft.id;
    context.push('/nfts/details/$detailId', extra: nft);
  }
}