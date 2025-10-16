import 'package:fpdart/fpdart.dart';
import 'package:routepractice/core/error/failure.dart';
import 'package:routepractice/features/favorites/data/favorites_service.dart';
import 'package:routepractice/features/favorites/domain/favorite_item.dart';
import 'package:routepractice/features/favorites/domain/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesService _service;

  FavoritesRepositoryImpl(this._service);

  @override
  Future<Either<Failure, List<FavoriteItem>>> getFavorites() async {
    try {
      final favorites = await _service.getFavorites();
      return right(favorites);
    } catch (e) {
      return left(Failure('Failed to load favorites: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(FavoriteItem item) async {
    try {
      await _service.addFavorite(item);
      return right(null);
    } catch (e) {
      return left(Failure('Failed to add favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String id, FavoriteType type) async {
    try {
      await _service.removeFavorite(id, type);
      return right(null);
    } catch (e) {
      return left(Failure('Failed to remove favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String id, FavoriteType type) async {
    try {
      final isFav = await _service.isFavorite(id, type);
      return right(isFav);
    } catch (e) {
      return left(Failure('Failed to check favorite status: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAll() async {
    try {
      await _service.clearAll();
      return right(null);
    } catch (e) {
      return left(Failure('Failed to clear favorites: $e'));
    }
  }
}
