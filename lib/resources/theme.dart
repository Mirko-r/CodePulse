import 'package:flutter/material.dart';

class AppTheme {
  // -------------------------
  // LIGHT THEME
  // -------------------------
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue.shade600,
    scaffoldBackgroundColor: Colors.grey.shade100,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 2,
    ),
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade300,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
      bodySmall: TextStyle(color: Colors.black54),
      titleMedium: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      filled: true,
      fillColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
  );

  // -------------------------
  // DARK THEME
  // -------------------------
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue.shade400,
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade500,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardColor: Colors.grey.shade800,
    dividerColor: Colors.grey.shade700,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
      bodySmall: TextStyle(color: Colors.white60),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      filled: true,
      fillColor: Colors.grey.shade800,
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
  );
}
