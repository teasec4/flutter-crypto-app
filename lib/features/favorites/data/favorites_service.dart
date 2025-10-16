import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:routepractice/features/favorites/domain/favorite_item.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites';

  Future<List<FavoriteItem>> getFavorites() async {
    final favoritesJson = await _getFavoritesJson();
    return favoritesJson.map((json) => FavoriteItem.fromJson(jsonDecode(json))).toList();
  }

  Future<List<String>> _getFavoritesJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> addFavorite(FavoriteItem item) async {
    final favorites = await getFavorites();
    print('🟢 Adding favorite: ${item.toJson()}');
    print('Before add: ${favorites.map((f) => f.id).toList()}');

    // Check if already exists
    if (!favorites.any((f) => f.id == item.id && f.type == item.type)) {
      favorites.add(item);
      print('✅ Added! After add: ${favorites.map((f) => f.id).toList()}');
      await _saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String id, FavoriteType type) async {
    final favorites = await getFavorites();
    favorites.removeWhere((f) => f.id == id && f.type == type);
    print('❌ Removed! After remove: ${favorites.map((f) => f.id).toList()}');
    await _saveFavorites(favorites);
  }

  Future<bool> isFavorite(String id, FavoriteType type) async {
    final favorites = await getFavorites();
    return favorites.any((f) => f.id == id && f.type == type);
  }

  Future<void> _saveFavorites(List<FavoriteItem> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = favorites.map((f) => jsonEncode(f.toJson())).toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }
}
