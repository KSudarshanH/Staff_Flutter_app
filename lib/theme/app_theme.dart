import 'package:flutter/material.dart';

class AppColors {
  // Deep Maroon Primary
  static const Color primary = Color(0xFF8B1D1D);
  static const Color primaryLight = Color(0xFFA63434);
  static const Color primaryDark = Color(0xFF6B1515);

  // Rich Gold Accent
  static const Color gold = Color(0xFFF4C430);
  static const Color goldLight = Color(0xFFFFD75E);
  static const Color goldDark = Color(0xFFD9A820);

  // Soft Cream / Ivory backgrounds
  static const Color ivory = Color(0xFFFAF9F6);
  static const Color ivoryDark = Color(0xFFF1F0EA);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

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
  static const Color textLight = slate500;
  static const Color border = slate200;
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.ivory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.gold,
        onSecondary: AppColors.slate900,
        surface: AppColors.white,
        onSurface: AppColors.slate900,
        error: AppColors.danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.slate900),
        titleTextStyle: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.slate100),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        labelStyle: const TextStyle(color: AppColors.slate500, fontSize: 14),
        hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 14),
      ),
    );
  }

  // Serif typography (Playfair Display)
  static TextStyle serif({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.slate900,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'PlayfairDisplay',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing ?? -0.02,
    );
  }

  // Sans-serif typography (Inter)
  static TextStyle sans({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.slate900,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
