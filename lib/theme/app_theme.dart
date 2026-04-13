import 'package:flutter/material.dart';

class AppColors {
  // Deep Maroon Primary
  static const Color primary = Color(0xFF8B1D1D);
  static const Color primaryLight = Color(0xFF9B2B2B);
  static const Color primaryDark = Color(0xFF6B1515);

  // Rich Gold Accent
  static const Color gold = Color(0xFFF4C430);
  static const Color goldLight = Color(0xFFD9A820);

  // Soft Cream / Ivory backgrounds
  static const Color ivory = Color(0xFFFAF9F6);

  // Status colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Base Neutrals
  static const Color white = Colors.white;
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Semantics
  static const Color text = slate900;
  static const Color red50 = Color(0xFFFEF2F2);
  static const Color red600 = Color(0xFFDC2626);
  static const Color indigo50 = Color(0xFFEEF2FF);
  static const Color indigo700 = Color(0xFF4338CA);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.ivory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.gold,
        surface: AppColors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.slate900),
      ),
      // We will define fonts via style helpers instead of global overrides
      // since Google Fonts needs async initialization or asset packaging
    );
  }

  // Serif typography (Playfair Display equivalent)
  static TextStyle serif({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.slate900,
  }) {
    return TextStyle(
      fontFamily: 'PlayfairDisplay', // Assumes you have this in pubspec
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: -0.02,
    );
  }

  // Sans-serif typography (Inter equivalent)
  static TextStyle sans({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.slate900,
  }) {
    return TextStyle(
      fontFamily: 'Inter', // Assumes you have this in pubspec
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }
}
