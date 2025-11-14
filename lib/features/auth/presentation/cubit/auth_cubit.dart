import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepractice/features/auth/data/auth_service.dart';
import 'package:routepractice/features/auth/domain/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _service;

  AuthCubit(this._service) : super(const AuthInitial()) {
    _initAuthListener();
  }

  /// 🧩 Подписка на изменения состояния авторизации
  void _initAuthListener() {
    _service.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
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
      emit(const AuthError('All fields are required'));
      return;
    }

    emit(const AuthLoading());

    final result = await _service.signUp(
      name: name,
      email: email,
      password: password,
    );

    result.match(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// 🟡 Вход
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(const AuthError('Email and password are required'));
      return;
    }

    emit(const AuthLoading());

    final result = await _service.signIn(
      email: email,
      password: password,
    );

    result.match(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// 🔄 Проверить текущего пользователя
  void checkAuthState() {
    final user = _service.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// 🔴 Выйти из аккаунта
  Future<void> signOut() async {
    await _service.signOut();
    emit(const AuthUnauthenticated());
  }

  /// ⚙️ Текущий пользователь (getter)
  UserModel? get currentUser => _service.getCurrentUser();

  /// ✅ Проверка авторизации
  bool get isAuthenticated => currentUser != null;
}
