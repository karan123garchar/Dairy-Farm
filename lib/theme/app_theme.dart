import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/smooth_page_route.dart';

// ─────────────────────────────────────────────────────────────
// App Theme — Krishna Dairy Farm
// Primary: Forest Green  #0C3823
// Surface: Warm Mint     #EFF6F1
// AppBar / Nav: Deep     #0C3823  (dark top bar)
// Card: White            #FFFFFF
// ─────────────────────────────────────────────────────────────

class AppTheme {
  // ── Brand Colors ──────────────────────────────────────────
  static const Color primary         = Color(0xFF0C3823); // deep forest green
  static const Color primaryDark     = Color(0xFF072718); // darker shade
  static const Color primaryMid      = Color(0xFF1F5C38); // mid shade
  static const Color primaryLight    = Color(0xFF2D6A4F); // lighter shade
  static const Color accent          = Color(0xFF22C55E); // bright leaf green
  static const Color accentLight     = Color(0xFF86EFAC); // mint green
  static const Color accentSoft      = Color(0xFFD1FAE5); // very light mint

  // ── Backgrounds ───────────────────────────────────────────
  static const Color scaffoldBg      = Color(0xFFEFF6F1); // warm mint tinted bg
  static const Color cardBg          = Color(0xFFFFFFFF);
  static const Color sectionBg       = Color(0xFFF4FAF6); // slightly tinted sections

  // ── AppBar & Nav ──────────────────────────────────────────
  static const Color appBarBg        = Color(0xFF0C3823); // deep green
  static const Color appBarFg        = Color(0xFFFFFFFF); // white title
  static const Color navBarBg        = Color(0xFF0C3823); // match appbar
  static const Color navBarSelected  = Color(0xFFD1FAE5); // soft mint pill
  static const Color navBarUnselected= Color(0xFFB0C9BB); // muted grey-green

  // ── Text ──────────────────────────────────────────────────
  static const Color textDark        = Color(0xFF1F2937);
  static const Color textMid         = Color(0xFF374151);
  static const Color textGrey        = Color(0xFF6B7280);
  static const Color textLight       = Color(0xFF9CA3AF);

  // ── Divider ───────────────────────────────────────────────
  static const Color divider         = Color(0xFFDDECE4);

  // ─────────────────────────────────────────────────────────
  // Global ThemeData
  // ─────────────────────────────────────────────────────────
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SmoothPageTransitionsBuilder(),
          TargetPlatform.iOS: SmoothPageTransitionsBuilder(),
          TargetPlatform.windows: SmoothPageTransitionsBuilder(),
          TargetPlatform.macOS: SmoothPageTransitionsBuilder(),
          TargetPlatform.linux: SmoothPageTransitionsBuilder(),
        },
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        surface: cardBg,
        surfaceContainerHighest: sectionBg,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
      ),

      // ── Scaffold ────────────────────────────────────────
      scaffoldBackgroundColor: scaffoldBg,

      // ── AppBar ──────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: appBarBg,
        foregroundColor: appBarFg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: appBarFg,
        ),
        iconTheme: IconThemeData(color: appBarFg),
        actionsIconTheme: IconThemeData(color: appBarFg),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // ── Card ────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: divider, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Divider ─────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),

      // ── Input ───────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: const TextStyle(color: textLight, fontSize: 13.5),
        labelStyle: const TextStyle(color: textGrey, fontSize: 13.5),
      ),

      // ── Elevated Button ─────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),

      // ── Text Button ─────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Chip ────────────────────────────────────────────
      chipTheme: const ChipThemeData(
        backgroundColor: accentSoft,
        labelStyle: TextStyle(
          color: primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }
}
