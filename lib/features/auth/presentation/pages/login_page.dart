import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:routepractice/features/auth/presentation/widgets/auth_field.dart';
import 'package:routepractice/features/auth/presentation/widgets/auth_gradient_btn.dart';

/// Converts technical auth errors to user-friendly messages
String _getUserFriendlyErrorMessage(String error) {
  final lowerError = error.toLowerCase();

  if (lowerError.contains('invalid login credentials') ||
      lowerError.contains('invalid_credentials') ||
      lowerError.contains('wrong password') ||
      lowerError.contains('email not confirmed')) {
    return 'Invalid email or password. Please check your credentials and try again.';
  }

  if (lowerError.contains('email not confirmed') ||
      lowerError.contains('email_not_confirmed')) {
    return 'Please check your email and click the confirmation link before signing in.';
  }

  if (lowerError.contains('too many requests') ||
      lowerError.contains('rate limit')) {
    return 'Too many login attempts. Please wait a moment before trying again.';
  }

  if (lowerError.contains('user not found') ||
      lowerError.contains('user_not_found')) {
    return 'No account found with this email address.';
  }

  if (lowerError.contains('network') ||
      lowerError.contains('connection') ||
      lowerError.contains('timeout')) {
    return 'Network error. Please check your internet connection and try again.';
  }

  if (lowerError.contains('email and password are required')) {
    return 'Please enter both email and password.';
  }

  // For any other error, provide a generic but helpful message
  return 'Something went wrong. Please try again or contact support if the problem persists.';
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Log In",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Show error message if any
            if (authState.hasError)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppPalette.error.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppPalette.error.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppPalette.error,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getUserFriendlyErrorMessage(authState.error.toString()),
                        style: TextStyle(
                          color: AppPalette.error,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            AuthField(hintText: 'Email', controller: emailController),
            const SizedBox(height: 15),
            AuthField(hintText: 'Password', controller: passwordController, isObscureText: true),
            const SizedBox(height: 15),

            AuthGradientButton(
              text: "Log In",
              nameController: TextEditingController(), // Not used for login
              emailController: emailController,
              passwordController: passwordController,
              isLogin: true,
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () => context.go('/signup'),
                  child: Text("Sign Up", style: TextStyle(color: AppPalette.accent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}