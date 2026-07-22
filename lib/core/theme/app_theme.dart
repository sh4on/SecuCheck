import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

// app theme configuration — dark security dashboard theme
abstract final class AppTheme {
  // dark theme used throughout the app
  static ThemeData get dark {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        onPrimary: AppColors.background,
      ),
      // card theme with rounded corners and no elevation
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),
      // app bar matching background with no shadow
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
        titleSpacing: AppSizes.pagePaddingH,
      ),
      // subtle dividers
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      // icon theme
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: AppSizes.iconLg,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
    );
  }
}
