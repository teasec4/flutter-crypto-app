import 'package:fpdart/fpdart.dart';
import 'package:routepractice/core/error/failure.dart';
import 'package:routepractice/features/favorites/domain/favorite_item.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteItem>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(FavoriteItem item);
  Future<Either<Failure, void>> removeFavorite(String id, FavoriteType type);
  Future<Either<Failure, bool>> isFavorite(String id, FavoriteType type);
  Future<Either<Failure, void>> clearAll();
}
