import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:routepractice/core/theme/app_palete.dart';

class CustomNavBar extends StatelessWidget{
  final StatefulNavigationShell navShell;

  const CustomNavBar({super.key, required this.navShell});

  void _onTap(int index, BuildContext context){
    if (index != navShell.currentIndex){
      navShell.goBranch(index, initialLocation: index == navShell.currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppPalette.accent..withOpacity(0.15),

              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.currency_bitcoin
                    , "Coins", 0, context),
                _buildNavItem(Icons.person, "Profile", 1, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, BuildContext context){
    final isActive = navShell.currentIndex == index;
    return GestureDetector(
      onTap: () => _onTap(index, context),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? Colors.white : Colors.grey, size: 26,),
            const SizedBox(height: 4,),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}