import 'dart:ui';

import 'package:flutter/material.dart';
class AppTheme {
  // رنگ‌های اصلی
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFFFF6584);
  static const Color accentColor = Color(0xFF43E97B);

  static const Color backgroundColor = Color(0xFF121212);
  static const Color buttonColor = Colors.greenAccent;

  // رنگ‌های پس‌زمینه
  static const Color bgLight = Color(0xFFF9FAFF);
  static const Color bgDark = Color(0xFF1F1D2B);

  // رنگ‌های درآمد و هزینه
  static const Color incomeColor = Color(0xFF43E97B);
  static const Color expenseColor = Color(0xFFFF6584);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgLight,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
      ),
      fontFamily: 'Vazir',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: Color(0xFF2D2C3C),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Vazir',
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: primaryColor.withOpacity(0.1),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazir',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        background: bgDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Vazir',
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF252836),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazir',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D2C3C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      useMaterial3: true,
    );
  }
}