import 'package:fpdart/fpdart.dart';
import 'package:routepractice/core/error/failure.dart';
import 'package:routepractice/features/nft/domain/nft.dart';

abstract class NFTRepository {
  Future<Either<Failure, Map<String, dynamic>>> getNFTCollections({String? continuation, int limit = 20});
  Future<Either<Failure, NFT>> getNFTDetails(String id);
}
