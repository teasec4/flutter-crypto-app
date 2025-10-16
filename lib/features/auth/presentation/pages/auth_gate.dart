import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/features/auth/presentation/viewmodels/auth_view_model.dart';

/// Simple auth gate that shows loading while checking auth state
/// Navigation is handled by GoRouter redirect in app_router.dart
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return authState.when(
      data: (user) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Authentication Error'),
              const SizedBox(height: 16),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(authViewModelProvider.notifier).checkAuthState(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}