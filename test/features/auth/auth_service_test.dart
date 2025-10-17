
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routepractice/core/error/failure.dart';
import 'package:routepractice/features/auth/data/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockAuth extends Mock implements GoTrueClient {}

void main() {
  late MockSupabaseClient mockClient;
  late MockAuth mockAuth;
  late AuthService authService;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockAuth();
    when(() => mockClient.auth).thenReturn(mockAuth);
    authService = AuthService(mockClient);
  });

  test('signUp returns UserModel on success', () async {
    // arrange
    final fakeUser = User(
      id: '123',
      email: 'test@example.com',
      userMetadata: {'name': 'Max'},
      appMetadata: {},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    );

    when(() => mockAuth.signUp(
      email: any(named: 'email'),
      password: any(named: 'password'),
      data: any(named: 'data'),
    )).thenAnswer((_) async => AuthResponse(user: fakeUser, session: null));

    // act
    final result = await authService.signUp(
      name: 'Max',
      email: 'test@example.com',
      password: '123456',
    );

    // assert
    expect(result.isRight(), true);
    result.match(
          (_) => fail('should be right'),
          (user) {
        expect(user.email, equals('test@example.com'));
        expect(user.name, equals('Max'));
      },
    );
  });

  test('signUp returns Failure on exception', () async {
    when(() => mockAuth.signUp(
      email: any(named: 'email'),
      password: any(named: 'password'),
      data: any(named: 'data'),
    )).thenThrow(Exception('Network error'));

    final result = await authService.signUp(
      name: 'Test',
      email: 'x@y.com',
      password: '123',
    );

    expect(result.isLeft(), true);
    result.match(
          (failure) => expect(failure, isA<Failure>()),
          (_) => fail('should be left'),
    );
  });
}
