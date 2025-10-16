
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routepractice/features/auth/data/auth_service.dart';
import 'package:routepractice/features/auth/domain/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// --- Providers --- ///

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(supabaseProvider));
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<UserModel?>>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthViewModel(service);
});

/// --- ViewModel --- ///

class AuthViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _service;

  AuthViewModel(this._service) : super(const AsyncLoading()) {
    _initAuthListener();
  }

  /// 🧩 Подписка на изменения состояния авторизации
  void _initAuthListener() {
    _service.authStateChanges.listen((user) {
      
      state = AsyncData(user);
    });
    checkAuthState();
  }

  /// 🟢 Регистрация
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      state = AsyncError('All fields are required', StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    final result = await _service.signUp(
      name: name,
      email: email,
      password: password,
    );

    result.match(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  /// 🟡 Вход
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      state = AsyncError('Email and password are required', StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    final result = await _service.signIn(
      email: email,
      password: password,
    );

    result.match(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  /// 🔄 Проверить текущего пользователя
  void checkAuthState() {
    final user = _service.getCurrentUser();
    state = AsyncData(user);
  }

  /// 🔴 Выйти из аккаунта
  Future<void> signOut() async {
    await _service.signOut();
    state = const AsyncData(null);
  }

  /// ⚙️ Текущий пользователь (getter)
  UserModel? get currentUser => _service.getCurrentUser();

  /// ✅ Проверка авторизации
  bool get isAuthenticated => currentUser != null;
}