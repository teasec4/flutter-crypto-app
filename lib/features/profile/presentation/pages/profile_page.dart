import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepractice/core/theme/app_palette.dart';
import 'package:routepractice/features/auth/presentation/auth_cubit.dart';
import 'package:routepractice/features/profile/presentation/widgets/profile_header.dart';
import 'package:routepractice/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:routepractice/features/profile/presentation/widgets/profile_section_header.dart';
import 'package:routepractice/features/profile/presentation/widgets/profile_logout_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return _buildProfileUI(context, authState);
      },
    );
  }

  Widget _buildProfileUI(BuildContext context, AuthState authState) {
    final user = authState is AuthAuthenticated ? authState.user : null;

    return SafeArea(
      child: Column(
        children: [
          ProfileHeader(user: user),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Account Section
                   ProfileSectionHeader(title: 'Account'),
                   ProfileMenuItem(
                     icon: Icons.person_outline,
                     title: 'Personal Information',
                     subtitle: 'Update your profile details',
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Personal Information - Coming Soon!')),
                       );
                     },
                   ),
                   ProfileMenuItem(
                     icon: Icons.notifications_outlined,
                     title: 'Notifications',
                     subtitle: 'Manage notification preferences',
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Notifications - Coming Soon!')),
                       );
                     },
                   ),
                   ProfileMenuItem(
                     icon: Icons.payment_outlined,
                     title: 'Payment Methods',
                     subtitle: 'Manage cards and wallets',
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Payment Methods - Coming Soon!')),
                       );
                     },
                   ),

                   const SizedBox(height: 24),

                   // Preferences Section
                   ProfileSectionHeader(title: 'Preferences'),
                   ProfileMenuItem(
                     icon: Icons.currency_exchange,
                     title: 'Default Currency',
                     subtitle: 'USD',
                     trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Currency Settings - Coming Soon!')),
                       );
                     },
                   ),
                   ProfileMenuItem(
                     icon: Icons.dark_mode_outlined,
                     title: 'Theme',
                     subtitle: 'Dark Mode',
                     trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Theme Settings - Coming Soon!')),
                       );
                     },
                   ),
                   ProfileMenuItem(
                     icon: Icons.language_outlined,
                     title: 'Language',
                     subtitle: 'English',
                     trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Language Settings - Coming Soon!')),
                       );
                     },
                   ),

                   const SizedBox(height: 24),

                   // Security Section
                   ProfileSectionHeader(title: 'Security'),
                   ProfileMenuItem(
                     icon: Icons.lock_outline,
                     title: 'Change Password',
                     subtitle: 'Update your account password',
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Change Password - Coming Soon!')),
                       );
                     },
                   ),
                   ProfileMenuItem(
                     icon: Icons.security_outlined,
                     title: 'Two-Factor Authentication',
                     subtitle: 'Add an extra layer of security',
                     trailing: Container(
                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                       decoration: BoxDecoration(
                         color: Colors.orange.withValues(alpha: 0.2),
                         borderRadius: BorderRadius.circular(8),
                       ),
                       child: const Text(
                         'Recommended',
                         style: TextStyle(
                           color: Colors.orange,
                           fontSize: 10,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ),
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Two-Factor Auth - Coming Soon!')),
                       );
                     },
                   ),
                   ProfileMenuItem(
                     icon: Icons.devices_outlined,
                     title: 'Connected Devices',
                     subtitle: 'Manage your logged in devices',
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Connected Devices - Coming Soon!')),
                       );
                     },
                   ),

                   const SizedBox(height: 24),

                   // App Info Section
                   ProfileSectionHeader(title: 'About'),
                   ProfileMenuItem(
                     icon: Icons.info_outline,
                     title: 'App Version',
                     subtitle: '1.0.0',
                     trailing: Container(
                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                       decoration: BoxDecoration(
                         color: AppPalette.primary.withValues(alpha: 0.2),
                         borderRadius: BorderRadius.circular(8),
                       ),
                       child: const Text(
                         'Latest',
                         style: TextStyle(
                           color: AppPalette.primary,
                           fontSize: 10,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ),
                   ),
                   ProfileMenuItem(
                     icon: Icons.help_outline,
                     title: 'Help & Support',
                     subtitle: 'Get help and contact support',
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Help & Support - Coming Soon!')),
                       );
                     },
                   ),
                   ProfileMenuItem(
                     icon: Icons.privacy_tip_outlined,
                     title: 'Privacy Policy',
                     subtitle: 'Read our privacy policy',
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Privacy Policy - Coming Soon!')),
                       );
                     },
                   ),
                   ProfileMenuItem(
                     icon: Icons.description_outlined,
                     title: 'Terms of Service',
                     subtitle: 'Read our terms and conditions',
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Terms of Service - Coming Soon!')),
                       );
                     },
                   ),

                   const SizedBox(height: 32),

                   // Logout Button
                   ProfileLogoutButton(
                     onPressed: () {
                       context.read<AuthCubit>().signOut();
                     },
                   ),

                   const SizedBox(height: 32),
                   ],
                   ),
                   ),
                   ),
                   ],
                   ),
                   );
                   }
                   }