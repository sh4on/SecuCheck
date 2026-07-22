import 'package:flutter/material.dart';

// app color palette — dark security dashboard theme with cyan accent
abstract final class AppColors {
  // background layers — deep navy hierarchy
  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceVariant = Color(0xFF1A2235);
  static const Color cardBorder = Color(0xFF1E2D45);

  // score ring gradient colors
  static const Color scoreGradientStart = Color(0xFF00E5FF);
  static const Color scoreGradientEnd = Color(0xFF00B4D8);

  // status indicator colors
  static const Color safe = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color critical = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // text hierarchy colors
  static const Color textPrimary = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF475569);

  // primary accent — cyan used for buttons and highlights
  static const Color accent = Color(0xFF00E5FF);

  // divider/separator color
  static const Color divider = Color(0xFF1E293B);
}
