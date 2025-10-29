import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/features/coin/presentation/widgets/empty_view.dart';
import 'package:routepractice/features/favorites/domain/favorite_item.dart';
import 'package:routepractice/features/favorites/presentation/favorites_view_model.dart';
import 'package:routepractice/features/nft/presentation/nft_view_model.dart';
import 'package:routepractice/features/nft/presentation/widgets/nft_empty_view.dart';
import 'package:routepractice/features/nft/presentation/widgets/nft_error_view.dart';
import 'package:routepractice/features/nft/presentation/widgets/nft_item.dart';

class NFTPage extends ConsumerStatefulWidget {
  const NFTPage({super.key});

  @override
  ConsumerState<NFTPage> createState() => _NFTPageState();
}

class _NFTPageState extends ConsumerState<NFTPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user scrolls near the bottom (200 pixels from bottom)
      ref.read(nftNotifierProvider.notifier).loadMore();
    }
  }

  void _toggleFavorite(dynamic nft) async {
    final favoritesNotifier = ref.read(favoritesNotifierProvider.notifier);
    final favoriteId = nft.contractAddress.isNotEmpty ? nft.contractAddress : nft.id;
    final isFavorite = await favoritesNotifier.isFavorite(favoriteId, FavoriteType.nft);

    if (isFavorite) {
      favoritesNotifier.removeFavorite(favoriteId, FavoriteType.nft);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${nft.name} removed from favorites'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } else {
      final favoriteItem = FavoriteItem.fromNFT(nft);
      favoritesNotifier.addFavorite(favoriteItem);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
            content: Text('❤️ ${nft.name} Added to favorites'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
            ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nftState = ref.watch(nftNotifierProvider);
    final isLoadingMore = ref.watch(nftNotifierProvider.notifier).isLoadingMore;

    return SafeArea(
      child: nftState.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, _) => NftErrorView(
            error: error.toString(),
            onRetry: () async => await ref.read(nftNotifierProvider.notifier).refresh()
        ),

        data: (nfts) {
          // empty list
          if(nfts.isEmpty){
            return NftEmptyView(onRetry: () async => await ref.read(nftNotifierProvider.notifier).refresh());
          }

          // data
          return RefreshIndicator(
            onRefresh: () => ref.read(nftNotifierProvider.notifier).refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: nfts.length + (isLoadingMore ? 1 : 0), // Add loading indicator
              itemBuilder: (context, index) {
                if (index == nfts.length) {
                  // Show loading indicator at the bottom
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final nft = nfts[index];
                return NFTItem(
                  nft: nft,
                  onToggleFavorite: () => _toggleFavorite(nft),
                );
              },
            ),
          );
        }
      ),
    );
  }
}
