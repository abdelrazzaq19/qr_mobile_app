import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color primaryColor = const Color(0xFF6366F1);
  static Color secondaryColor = const Color(0xFF06B6D4);
  static Color backgroundColor = const Color(0xFF0F172A);
  static Color surfaceColor = const Color(0xFF1E293B);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      onSurface: Colors.white,
      outline: Colors.white10,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
  );
}
