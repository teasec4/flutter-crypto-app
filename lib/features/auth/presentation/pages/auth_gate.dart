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
        // not auth-ed
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go('/login');
          });
        } else {
          // auth-ed
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go('/coins');
          });
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Colors.pinkAccent),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.pinkAccent),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Auth error: $e')),
      ),
    );
  }
}