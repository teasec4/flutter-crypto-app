
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routepractice/features/auth/data/auth_service.dart';
import 'package:routepractice/features/auth/domain/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(supabaseProvider));
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<UserModel?>>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthViewModel(service);
});

class AuthViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _service;

  AuthViewModel(this._service) : super(const AsyncData(null)) {
    _listenToAuthChanges();
  }

  /// Listen to auth changes from Supabase
  void _listenToAuthChanges() {
    _service.authStateChanges.listen((user) {
      state = AsyncData(user);
    });
  }

  /// Sign up with validation
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // Basic form validation
    if (name.trim().isEmpty) {
      state = AsyncError('Name is required', StackTrace.current);
      return;
    }
    if (email.trim().isEmpty) {
      state = AsyncError('Email is required', StackTrace.current);
      return;
    }
    if (password.trim().isEmpty) {
      state = AsyncError('Password is required', StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    final result = await _service.signUp(
      name: name.trim(),
      email: email.trim(),
      password: password.trim(),
    );

    result.match(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  /// Sign in with validation
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // Basic form validation
    if (email.trim().isEmpty) {
      state = AsyncError('Email is required', StackTrace.current);
      return;
    }
    if (password.trim().isEmpty) {
      state = AsyncError('Password is required', StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    final result = await _service.signIn(
      email: email.trim(),
      password: password.trim(),
    );

    result.match(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  /// Check current authentication state
  void checkAuthState() {
    final user = _service.getCurrentUser();
    state = AsyncData(user);
  }

  /// Sign out
  Future<void> signOut() async {
    await _service.signOut();
    state = const AsyncData(null);
  }

  /// Get current user without changing state
  UserModel? get currentUser => _service.getCurrentUser();

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;
}