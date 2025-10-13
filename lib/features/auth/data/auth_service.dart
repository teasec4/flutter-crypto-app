import 'package:routepractice/core/error/failure.dart';
import 'package:routepractice/features/auth/domain/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';

class AuthService {
  final SupabaseClient supabase;

  AuthService(this.supabase);

  Future<Either<Failure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final user = response.user;
      if (user == null) throw Exception('Register failed');

      return right(UserModel(
        id: user.id, 
        email: user.email ?? '', 
        name: user.userMetadata?['name'] ?? name,
        ));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try{
      final response = await supabase.auth.signInWithPassword(
        email:email,
        password:password,
      );
      final user = response.user;
      if(user == null) throw Exception('Invalid credentials');

      return right(UserModel(
        id: user.id, 
        email: user.email ?? '', 
        name: user.userMetadata?['name']),
        );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  UserModel? getCurrentUser() {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    return UserModel(
      id: user.id, 
        email: user.email ?? '', 
        name: user.userMetadata?['name'],
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}