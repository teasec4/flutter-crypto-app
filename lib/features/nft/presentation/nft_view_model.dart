import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routepractice/features/nft/data/nft_repository_impl.dart';
import 'package:routepractice/features/nft/data/nft_service.dart';
import 'package:routepractice/features/nft/domain/nft.dart';
import 'package:routepractice/features/nft/domain/nft_repository.dart';

final nftServiceProvider = Provider<NFTService>((ref) {
  return NFTService();
});

final nftRepositoryProvider = Provider<NFTRepository>((ref) {
  final nftService = ref.watch(nftServiceProvider);
  return NFTRepositoryImpl(nftService: nftService);
});

final nftNotifierProvider =
    StateNotifierProvider<NFTNotifier, AsyncValue<List<NFT>>>((ref) {
  final repo = ref.watch(nftRepositoryProvider);
  return NFTNotifier(repo);
});

class NFTNotifier extends StateNotifier<AsyncValue<List<NFT>>> {
  final NFTRepository _repo;
  String? _continuationToken;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  bool get isLoadingMore => _isLoadingMore;

  NFTNotifier(this._repo) : super(const AsyncLoading()) {
    loadCollections();
  }

  Future<void> loadCollections() async {
    state = const AsyncLoading();
    _continuationToken = null;
    _hasMore = true;

    final result = await _repo.getNFTCollections(limit: 20);

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (data) {
        final nfts = data['collections'] as List<NFT>;
        _continuationToken = data['continuation'] as String?;
        _hasMore = _continuationToken != null && _continuationToken!.isNotEmpty;
        state = AsyncData(nfts);
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    final result = await _repo.getNFTCollections(
      continuation: _continuationToken,
      limit: 20,
    );

    result.fold(
      (failure) {
        // On error, stop loading more but don't change current state
        _isLoadingMore = false;
      },
      (data) {
        final moreNfts = data['collections'] as List<NFT>;
        final newContinuation = data['continuation'] as String?;

        if (moreNfts.isNotEmpty) {
          final current = state.value ?? [];
          state = AsyncData([...current, ...moreNfts]);
          _continuationToken = newContinuation;
          _hasMore = newContinuation != null && newContinuation.isNotEmpty;
        } else {
          _hasMore = false;
        }

        _isLoadingMore = false;
      },
    );
  }

  Future<void> refresh() async {
    await loadCollections();
  }
}
