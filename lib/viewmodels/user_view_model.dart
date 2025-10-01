import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/coin.dart';

final userProvider =
    AsyncNotifierProvider<UserNotifier, User?>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<User?> {
  late final Box<User> _userBox;
  late final Box<Coin> _coinsBox;

  @override
  Future<User?> build() async {
    _userBox = Hive.box<User>('userBox');
    _coinsBox = Hive.box<Coin>('coinsBoxV2');

    if (_userBox.isEmpty) return null;

    final u = _userBox.getAt(0);
    // возвращаем только если реально залогинен
    return (u != null && u.isLoggedIn) ? u : null;
  }

  // 👇 Добавляем публичный геттер
  Box<Coin> get coinsBox => _coinsBox;

  /// 🔹 Регистрация нового пользователя
  Future<void> register(String name, String password) async {
    final user = User(
      name: name,
      password: password,
      favoriteIds: [],
      isLoggedIn: true,
    );

    if (_userBox.isEmpty) {
      await _userBox.add(user);
    } else {
      await _userBox.putAt(0, user);
    }

    state = AsyncValue.data(user);
  }

  /// 🔹 Вход (true = успех, false = ошибка)
  Future<bool> login(String name, String password) async {
    if (_userBox.isEmpty) return false;
    final u = _userBox.getAt(0);
    if (u == null) return false;

    if (u.name == name && u.password == password) {
      final updated = u.copyWith(isLoggedIn: true);
      await _userBox.putAt(0, updated);
      state = AsyncValue.data(updated);
      return true;
    }
    return false;
  }

  /// 🔹 Выход
  Future<void> logout() async {
    if (_userBox.isNotEmpty) {
      final u = _userBox.getAt(0);
      if (u != null) {
        final updated = u.copyWith(isLoggedIn: false);
        await _userBox.putAt(0, updated);
      }
    }
    state = const AsyncData(null);
  }

  /// 🔹 Добавить/удалить из избранного
  Future<void> toggleFavorite(String coinId) async {
    final user = state.value;
    if (user == null) return;

    final favs = List<String>.from(user.favoriteIds);
    favs.contains(coinId) ? favs.remove(coinId) : favs.add(coinId);

    final updated = user.copyWith(favoriteIds: favs);
    await _userBox.putAt(0, updated);
    state = AsyncValue.data(updated);
  }

  /// 🔹 Получить избранные монеты
  List<Coin> getFavorites() {
    final user = state.value;
    if (user == null) return [];
    return user.favoriteIds
        .map((id) => _coinsBox.get(id))
        .whereType<Coin>()
        .toList();
  }
}