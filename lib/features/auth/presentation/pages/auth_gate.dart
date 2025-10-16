import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/features/auth/presentation/viewmodels/auth_view_model.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return authState.when(
      data: (user) {
        // если пользователь залогинен → сразу ведём на /coins
        if (user != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/coins');
          });
        } 
        // если нет → на /login
        else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
        }

        // пока переход — просто крутилка
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Authentication Error', style: TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              Text(error.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(authViewModelProvider.notifier)
                    .checkAuthState(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}