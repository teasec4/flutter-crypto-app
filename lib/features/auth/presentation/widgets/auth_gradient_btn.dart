import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/auth/presentation/viewmodels/auth_view_model.dart';

/// Simple auth button that calls auth methods
/// Navigation is handled by GoRouter redirects
class AuthGradientButton extends ConsumerWidget {
  final String text;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLogin;

  const AuthGradientButton({
    super.key,
    required this.text,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    this.isLogin = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.primary, AppPalette.accent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppPalette.accent.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                final viewModel = ref.read(authViewModelProvider.notifier);

                if (isLogin) {
                  await viewModel.signIn(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                } else {
                  await viewModel.signUp(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}