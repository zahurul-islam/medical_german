/// App theme configuration for MedDeutsch
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.accent,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      error: AppColors.error,
      onError: Colors.white,
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryLight,
      ),
    ),
    
    cardTheme: const CardThemeData(
      color: AppColors.cardLight,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dividerLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      hintStyle: GoogleFonts.outfit(
        color: AppColors.textHintLight,
        fontSize: 14,
      ),
      labelStyle: GoogleFonts.outfit(
        color: AppColors.textSecondaryLight,
        fontSize: 14,
      ),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHintLight,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
    ),
    
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.dividerLight,
    ),
    
    textTheme: GoogleFonts.outfitTextTheme().apply(
      bodyColor: AppColors.textPrimaryLight,
      displayColor: AppColors.textPrimaryLight,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.accent,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.error,
      onError: Colors.white,
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
      ),
    ),
    
    cardTheme: const CardThemeData(
      color: AppColors.cardDark,
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        textStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dividerDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dividerDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      hintStyle: GoogleFonts.outfit(
        color: AppColors.textHintDark,
        fontSize: 14,
      ),
      labelStyle: GoogleFonts.outfit(
        color: AppColors.textSecondaryDark,
        fontSize: 14,
      ),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textHintDark,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
    ),
    
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryLight,
      linearTrackColor: AppColors.dividerDark,
    ),
    
    textTheme: GoogleFonts.outfitTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    
    // Ensure all text is white in dark mode
    listTileTheme: const ListTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white70,
    ),
    
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );
}
