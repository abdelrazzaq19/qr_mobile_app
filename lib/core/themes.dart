import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Palette ────────────────────────────────────────────────
  static const Color bg = Color(0xFF060A18);
  static const Color surface = Color(0xFF0F1628);
  static const Color surface2 = Color(0xFF151D35);
  static const Color border = Color(0xFF1E2A4A);
  static const Color accent = Color(0xFFFF6B35);
  static const Color accentAlt = Color(0xFFFFB443);
  static const Color textPri = Color(0xFFF0F4FF);
  static const Color textSec = Color(0xFF6B7A99);
  static const Color success = Color(0xFF34D399);
  static const Color danger = Color(0xFFFF5A5A);
  static const Color info = Color(0xFF60A5FA);

  // Legacy aliases kept for controllers that reference AppTheme
  static Color primaryColor = accent;
  static Color secondaryColor = accentAlt;
  static Color backgroundColor = bg;
  static Color surfaceColor = surface;

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    fontFamily: GoogleFonts.dmSans().fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: accentAlt,
      surface: surface,
      onSurface: textPri,
      outline: border,
      error: danger,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.dmSans(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: textPri,
        letterSpacing: -0.3,
      ),
      iconTheme: const IconThemeData(color: textPri),
    ),
    cardTheme: CardThemeData(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: border),
      ),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: danger),
      ),
      labelStyle: const TextStyle(color: textSec),
      hintStyle: const TextStyle(color: textSec),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: GoogleFonts.dmSans(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: accent,
      unselectedItemColor: textSec,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(color: border, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surface2,
      contentTextStyle: GoogleFonts.dmSans(color: textPri),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
