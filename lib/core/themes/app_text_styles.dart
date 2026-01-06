/// App-wide text styles for MedDeutsch
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Headings
  static TextStyle heading1({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      height: 1.2,
    );
  }

  static TextStyle heading2({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      height: 1.3,
    );
  }

  static TextStyle heading3({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      height: 1.4,
    );
  }

  static TextStyle heading4({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      height: 1.4,
    );
  }

  // Body Text
  static TextStyle bodyLarge({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      height: 1.5,
    );
  }

  static TextStyle bodyMedium({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      height: 1.5,
    );
  }

  static TextStyle bodySmall({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
      height: 1.5,
    );
  }

  // Button Text
  static TextStyle buttonLarge({Color? color}) {
    return GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      letterSpacing: 0.5,
    );
  }

  static TextStyle buttonMedium({Color? color}) {
    return GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      letterSpacing: 0.5,
    );
  }

  // Label Text
  static TextStyle labelLarge({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  static TextStyle labelMedium({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  static TextStyle labelSmall({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: color ?? (isDark ? AppColors.textHintDark : AppColors.textHintLight),
    );
  }

  // German Text (for vocabulary and dialogues)
  static TextStyle germanWord({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: color ?? (isDark ? Colors.white : AppColors.primary),
      height: 1.3,
    );
  }

  static TextStyle germanPhrase({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      fontStyle: FontStyle.italic,
      height: 1.4,
    );
  }

  static TextStyle pronunciation({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
      fontStyle: FontStyle.italic,
    );
  }

  // Translation Text
  static TextStyle translation({Color? color, bool isDark = false}) {
    return GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
      height: 1.5,
    );
  }

  // Level Badge
  static TextStyle levelBadge({Color? color}) {
    return GoogleFonts.outfit(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: color ?? Colors.white,
      letterSpacing: 1.0,
    );
  }
}
