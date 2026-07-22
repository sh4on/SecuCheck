import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// typography definitions — inter font family, no screenutil text scaling applied per project rules
abstract final class AppTextStyles {
  // large display number (used for score on report screen)
  static final TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -2.0,
    height: 1.0,
  );

  // page/section headings
  static final TextStyle headingLarge = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  // card and dialog titles
  static final TextStyle headingMedium = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // small section headers and labels
  static final TextStyle headingSmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  // primary body text
  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // secondary body / description text
  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // caption and detail text
  static final TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // badge and tag labels (uppercase intent)
  static final TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppColors.textPrimary,
  );

  // large score number shown in the circular ring
  static final TextStyle scoreNumber = GoogleFonts.inter(
    fontSize: 52,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -3.0,
    height: 1.0,
  );
}
