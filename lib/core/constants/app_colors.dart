import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF6C63FF); // Modern Violet-Blue
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color accent = Color(
    0xFF00C896,
  ); // Minty Teal for success/growth

  // Neutrals (Dark Theme)
  static const Color backgroundDark = Color(0xFF141419); // Very dark blue-grey
  static const Color surfaceDark = Color(0xFF1E1E24);
  static const Color surfaceDarkVariant = Color(0xFF2B2B36);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFB0B0C0);

  // Neutrals (Light Theme)
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2D2D3A);

  // Semantic
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF00C896);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF29B6F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2B2B36), Color(0xFF22222B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
