import 'package:flutter/material.dart';

/// Color Tokens for XDesk
/// 
/// Dark mode only color palette.
/// Sadece bu renkler kullanılacak.
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF121212);
  static const Color grey = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF808080);
  static const Color textDisabled = Color(0xFF4D4D4D);

  // Background Colors
  static const Color backgroundPrimary = black;
  static const Color backgroundSecondary = darkGrey;
  static const Color backgroundTertiary = grey;

  // Surface Colors
  static const Color surfacePrimary = darkGrey;
  static const Color surfaceSecondary = grey;
  static const Color surfaceElevated = Color(0xFF2C2C2C);

  // Border Colors
  static const Color borderPrimary = Color(0xFF333333);
  static const Color borderSecondary = Color(0xFF1A1A1A);

  // Accent Colors (gelecekte kullanılabilir)
  static const Color accent = Color(0xFF6200EE);
  static const Color accentVariant = Color(0xFF3700B3);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
}

