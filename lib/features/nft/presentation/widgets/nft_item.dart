import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/nft/domain/nft.dart';

class NFTItem extends StatelessWidget {
  final NFT nft;

  const NFTItem({super.key, required this.nft});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          print('🖱️ Tapping NFT: ${nft.name}');
          print('🆔 Slug: ${nft.id}');
          print('🏠 Contract: ${nft.contractAddress}');
          // Use contract address for detail lookup if available, otherwise use slug
          final detailId = nft.contractAddress.isNotEmpty ? nft.contractAddress : nft.id;
          print('🎯 Using for detail lookup: $detailId (${nft.contractAddress.isNotEmpty ? 'contract' : 'slug'})');
          print('🔗 Navigation path: /nfts/details/$detailId');
          context.push('/nfts/details/$detailId');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // NFT Image
              if (nft.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    nft.imageUrl!,
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
                      child: const Icon(
                        Icons.image_not_supported,
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
                  child: const Icon(
                    Icons.collections,
                    color: Colors.white54,
                    size: 24,
                  ),
                ),

              const SizedBox(width: 16),

              // NFT Info
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
                    if (nft.floorPrice != null && nft.floorPriceCurrency != null) ...[
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
    );
  }
}
