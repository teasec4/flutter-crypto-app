
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routepractice/features/auth/data/auth_service.dart';
import 'package:routepractice/features/auth/domain/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final authServiceProvider = Provider<AuthService>((ref){
  return AuthService(ref.watch(supabaseProvider));
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<UserModel?>>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthViewModel(service);
});

class AuthViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _service;

  AuthViewModel(this._service) : super(const AsyncData(null)){
    _listenToAuthChanges();
  }
  /// listen to auth changes from supabsae
  void _listenToAuthChanges() {
    _service.supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session == null) {
        state = const AsyncData(null);
      } else {
        final user = _service.getCurrentUser();
        state = AsyncData(user);
      }
    });
  }

  /// r]sign up
  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncLoading();
    final result = await _service.signUp(name: name, email: email, password: password);

    result.match(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  /// sign in
  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    final result = await _service.signIn(email: email, password: password);

    result.match(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  /// checking auth
  void loadCurrentUser() {
    final user = _service.getCurrentUser();
    state = AsyncData(user);
  }

  /// log out
  Future<void> signOut() async {
    await _service.signOut();
    state = const AsyncData(null);
  }
}