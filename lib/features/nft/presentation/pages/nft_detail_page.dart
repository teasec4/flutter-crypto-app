import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/nft/domain/nft.dart';
import 'package:routepractice/features/nft/presentation/nft_detail_view_model.dart';

class NFTDetailPage extends ConsumerWidget {
  final String nftId;
  final NFT? nft;

  const NFTDetailPage({super.key, required this.nftId, this.nft});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nftDetailState = ref.watch(nftDetailNotifierProvider(nftId));

    return SafeArea(
      child: 
      nftDetailState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(nftDetailNotifierProvider(nftId).notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (nft) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NFT Image
              if (nft.imageUrl != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      nft.imageUrl!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: AppPalette.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // NFT Name and Symbol
              Text(
                nft.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${nft.symbol.toUpperCase()} • ${nft.assetPlatformId}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 32),

              // Market Data
              _buildInfoCard(
                'Floor Price',
                nft.floorPrice != null && nft.floorPriceCurrency != null
                    ? '${nft.floorPrice!.toStringAsFixed(4)} ${nft.floorPriceCurrency}'
                    : 'N/A',
              ),

              const SizedBox(height: 16),

              _buildInfoCard(
                'Market Cap',
                nft.marketCap != null
                    ? '\$${nft.marketCap!.toStringAsFixed(0)}'
                    : 'N/A',
              ),

              const SizedBox(height: 16),

              _buildInfoCard(
                '24h Volume',
                nft.volume24h != null
                    ? '\$${nft.volume24h!.toStringAsFixed(0)}'
                    : 'N/A',
              ),

              const SizedBox(height: 16),

              if (nft.priceChange24h != null)
                _buildInfoCard(
                  '24h Change',
                  '${nft.priceChange24h! >= 0 ? '+' : ''}${nft.priceChange24h!.toStringAsFixed(2)}%',
                  color: nft.priceChange24h! >= 0 ? Colors.green : Colors.red,
                ),

              const SizedBox(height: 32),

              // Contract Address
              _buildInfoCard(
                'Contract Address',
                nft.contractAddress,
                fontSize: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, {Color? color, double fontSize = 16}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: color ?? Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
