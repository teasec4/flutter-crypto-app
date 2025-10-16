import 'package:flutter/material.dart';
import 'package:routepractice/core/theme/app_palete.dart';

class AppTheme{
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.background,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.surface.withValues(alpha: 0.6),
      hintStyle: const TextStyle(color: AppPalette.textSecondary, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppPalette.accent, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppPalette.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppPalette.error, width: 1.8),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
  );
}