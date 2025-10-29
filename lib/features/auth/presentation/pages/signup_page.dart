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

  if (lowerError.contains('user already registered') ||
      lowerError.contains('user_already_exists') ||
      lowerError.contains('email already exists')) {
    return 'An account with this email already exists. Try signing in instead.';
  }

  if (lowerError.contains('password should be at least')) {
    return 'Password must be at least 6 characters long.';
  }

  if (lowerError.contains('invalid email') ||
      lowerError.contains('email_invalid')) {
    return 'Please enter a valid email address.';
  }

  if (lowerError.contains('weak password') ||
      lowerError.contains('password_weak')) {
    return 'Password is too weak. Please choose a stronger password.';
  }

  if (lowerError.contains('signup is disabled') ||
      lowerError.contains('signup_disabled')) {
    return 'New account registration is currently disabled.';
  }

  if (lowerError.contains('name') && lowerError.contains('required')) {
    return 'Please enter your name.';
  }

  if (lowerError.contains('all fields are required')) {
    return 'Please fill in all required fields.';
  }

  if (lowerError.contains('network') ||
      lowerError.contains('connection') ||
      lowerError.contains('timeout')) {
    return 'Network error. Please check your internet connection and try again.';
  }

  // Fallback to login error handler for common errors
  if (lowerError.contains('invalid login credentials') ||
      lowerError.contains('invalid_credentials') ||
      lowerError.contains('too many requests')) {
    return 'Unable to create account. Please try again later.';
  }

  // For any other error, provide a generic but helpful message
  return 'Unable to create account. Please try again or contact support if the problem persists.';
}

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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
              "Sign Up",
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

            AuthField(hintText: 'Name', controller: nameController),
            const SizedBox(height: 15),
            AuthField(hintText: 'Email', controller: emailController),
            const SizedBox(height: 15),
            AuthField(
              hintText: 'Password',
              controller: passwordController,
              isObscureText: true,
            ),
            const SizedBox(height: 15),

            AuthGradientButton(
              text: "Create Account",
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              isLogin: false,
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text("Sign In", style: TextStyle(color: AppPalette.accent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
