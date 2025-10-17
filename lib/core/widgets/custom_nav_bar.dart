import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/theme/app_palete.dart';

class CustomNavBar extends StatelessWidget {
  final StatefulNavigationShell navShell;

  const CustomNavBar({super.key, required this.navShell});

  void _onTap(int index, BuildContext context) {
    if (index != navShell.currentIndex) {
      navShell.goBranch(index, initialLocation: index == navShell.currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppPalette.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.currency_bitcoin, "Coins", 0, context),
          _buildNavItem(Icons.collections, "NFT", 1, context),
          _buildNavItem(Icons.favorite_border, "Favorites", 2, context),
          _buildNavItem(Icons.person_outline, "Profile", 3, context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, BuildContext context) {
    final isActive = navShell.currentIndex == index;
    return GestureDetector(
      onTap: () => _onTap(index, context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppPalette.accent.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppPalette.accent : Colors.white.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppPalette.accent : Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}