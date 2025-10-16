import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routepractice/features/favorites/data/favorites_repository_impl.dart';
import 'package:routepractice/features/favorites/data/favorites_service.dart';
import 'package:routepractice/features/favorites/domain/favorite_item.dart';
import 'package:routepractice/features/favorites/domain/favorites_repository.dart';

final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final service = ref.watch(favoritesServiceProvider);
  return FavoritesRepositoryImpl(service);
});

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<FavoriteItem>>>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repo);
});

final isFavoriteProvider = Provider.family<bool, ({String id, FavoriteType type})>((ref, params) {
  final favoritesAsync = ref.watch(favoritesNotifierProvider);
  return favoritesAsync.maybeWhen(
    data: (favorites) => favorites.any((f) => f.id == params.id && f.type == params.type),
    orElse: () => false,
  );
});

class FavoritesNotifier extends StateNotifier<AsyncValue<List<FavoriteItem>>> {
  final FavoritesRepository _repo;

  FavoritesNotifier(this._repo) : super(const AsyncLoading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = const AsyncLoading();
    final result = await _repo.getFavorites();

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (favorites) => state = AsyncData(favorites),
    );
  }

  Future<void> addFavorite(FavoriteItem item) async {
    final result = await _repo.addFavorite(item);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => loadFavorites(), // Reload favorites
    );
  }

  Future<void> removeFavorite(String id, FavoriteType type) async {
    final result = await _repo.removeFavorite(id, type);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => loadFavorites(), // Reload favorites
    );
  }

  Future<bool> isFavorite(String id, FavoriteType type) async {
    final result = await _repo.isFavorite(id, type);
    return result.getOrElse((failure) => false);
  }

  Future<void> clearAll() async {
    final result = await _repo.clearAll();
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => state = const AsyncData([]),
    );
  }
}
