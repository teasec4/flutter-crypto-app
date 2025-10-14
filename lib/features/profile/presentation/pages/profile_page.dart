import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/features/profile/presentation/viewmodels/profile_view_model.dart';
import 'package:routepractice/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileVM = ref.watch(profileViewModelProvider);
    final authState = ref.watch(authViewModelProvider);

    final user = authState.value;

    return SafeArea(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user != null ? "Welcome, ${user.name ?? user.email}" : "No user",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
        
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text("Log out"),
                  onPressed: () async {
                    profileVM.logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }
}