import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/features/nft/presentation/nft_view_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final nftState = ref.watch(nftNotifierProvider);
    final isLoadingMore = ref.watch(nftNotifierProvider.notifier).isLoadingMore;

    return SafeArea(
      child: nftState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(nftNotifierProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (nfts) => RefreshIndicator(
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
              return NFTItem(nft: nft);
            },
          ),
        ),
      ),
    );
  }
}
