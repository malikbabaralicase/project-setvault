import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.deepMidnightNavy,
      primaryColor: AppColors.electricBlue,
      canvasColor: AppColors.darkNavy,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.electricBlue,
        secondary: AppColors.cyan,
        surface: AppColors.darkNavy,
        error: AppColors.error,
        onPrimary: AppColors.primaryWhite,
        onSecondary: AppColors.deepMidnightNavy,
        onSurface: AppColors.primaryWhite,
        onError: AppColors.primaryWhite,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.primaryWhite),
        titleTextStyle: TextStyle(
          color: AppColors.primaryWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.glassBorderSubtle,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.mutedBlue,
      ),
    );
  }
}
