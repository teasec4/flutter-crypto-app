import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:routepractice/features/auth/presentation/widgets/auth_field.dart';
import 'package:routepractice/features/auth/presentation/widgets/auth_gradient_btn.dart';

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
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  authState.error.toString(),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
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