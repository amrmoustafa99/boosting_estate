import 'package:flutter/material.dart';

class AppTheme {
  //  Our Colors
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFFEBF0FF);
  static const Color primaryDark = Color(0xFF1240A8);
  static const Color accent = Color(0xFFFF6B35);
  static const Color success = Color(0xFF0BAD6F);
  static const Color successLight = Color(0xFFE6F9F2);
  static const Color warning = Color(0xFFF5A623);
  static const Color warningLight = Color(0xFFFFF8EC);
  static const Color error = Color(0xFFE53E3E);
  static const Color errorLight = Color(0xFFFFF5F5);
  static const Color gold = Color(0xFFD4A017);
  static const Color goldLight = Color(0xFFFFF9E6);
  static const Color instagramPink = Color(0xFFE1306C);
  static const Color instagramPurple = Color(0xFF833AB4);
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color whatsappGreenLight = Color(0xFFE8FDF1);

  // ── Neutrals ──────────────────────────────────────────────────
  static const Color background = Color(0xFFF4F6FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFFADB5BD);

  // ── Spacing ───────────────────────────────────────────────────
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;

  // ── Radius ────────────────────────────────────────────────────
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
  static List<BoxShadow> get shadowPrimary => [
    BoxShadow(
      color: primary.withOpacity(0.25),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
  static List<BoxShadow> get shadowGold => [
    BoxShadow(
      color: gold.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // ── ThemeData ─────────────────────────────────────────────────
  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: background,
    fontFamily: 'SF Pro Display',
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
    ),
  );
}
