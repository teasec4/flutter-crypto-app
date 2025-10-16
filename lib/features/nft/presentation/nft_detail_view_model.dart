import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routepractice/features/nft/domain/nft.dart';
import 'package:routepractice/features/nft/domain/nft_repository.dart';
import 'package:routepractice/features/nft/presentation/nft_view_model.dart';

final nftDetailNotifierProvider = StateNotifierProvider.family<NFTDetailNotifier, AsyncValue<NFT>, String>((ref, nftId) {
  final repo = ref.watch(nftRepositoryProvider);
  return NFTDetailNotifier(repo: repo, nftId: nftId)..loadDetails();
});

class NFTDetailNotifier extends StateNotifier<AsyncValue<NFT>> {
  final NFTRepository _repo;
  final String _nftId;

  NFTDetailNotifier({required NFTRepository repo, required String nftId})
      : _repo = repo,
        _nftId = nftId,
        super(const AsyncLoading());

  Future<void> loadDetails() async {
    state = const AsyncLoading();
    final result = await _repo.getNFTDetails(_nftId);

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (nft) => state = AsyncData(nft),
    );
  }

  Future<void> refresh() async {
    await loadDetails();
  }
}
