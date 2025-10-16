import 'package:fpdart/fpdart.dart';
import 'package:routepractice/core/error/failure.dart';
import 'package:routepractice/features/nft/data/nft_service.dart';
import 'package:routepractice/features/nft/domain/nft.dart';
import 'package:routepractice/features/nft/domain/nft_repository.dart';

class NFTRepositoryImpl implements NFTRepository {
  final NFTService nftService;

  NFTRepositoryImpl({required this.nftService});

  @override
  Future<Either<Failure, Map<String, dynamic>>> getNFTCollections({String? continuation, int limit = 20}) async {
    return await nftService.getNFTCollections(continuation: continuation, limit: limit);
  }

  @override
  Future<Either<Failure, NFT>> getNFTDetails(String id) async {
    return await nftService.getNFTDetails(id);
  }
}
