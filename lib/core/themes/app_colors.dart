/// App-wide color constants for MedDeutsch
import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors - Medical Blue Theme
  static const Color primary = Color(0xFF1A5F7A);
  static const Color primaryLight = Color(0xFF2D8BB4);
  static const Color primaryDark = Color(0xFF0F3D4F);
  
  // Secondary Colors - Healing Green
  static const Color secondary = Color(0xFF57C5B6);
  static const Color secondaryLight = Color(0xFF7FD8CB);
  static const Color secondaryDark = Color(0xFF3A9E91);
  
  // Accent Colors
  static const Color accent = Color(0xFFF39C12);
  static const Color accentLight = Color(0xFFF5B041);
  static const Color accentDark = Color(0xFFD68910);
  
  // Level Colors
  static const Color levelA1 = Color(0xFF4CAF50);  // Green
  static const Color levelA2 = Color(0xFF8BC34A);  // Light Green
  static const Color levelB1 = Color(0xFFFFC107);  // Amber
  static const Color levelB2 = Color(0xFFFF9800);  // Orange
  static const Color levelC1 = Color(0xFFF44336);  // Red
  
  // Background Colors - Light Theme
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  
  // Background Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF0A1929);
  static const Color surfaceDark = Color(0xFF132F4C);
  static const Color cardDark = Color(0xFF1E3A5F);
  
  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B6B80);
  static const Color textHintLight = Color(0xFF9E9EB3);
  
  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB0BEC5);
  static const Color textHintDark = Color(0xFF78909C);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Divider Colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF374151);
  
  // Shadow Color
  static const Color shadow = Color(0x1A000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Phase Gradients
  static const LinearGradient phase1Gradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient phase2Gradient = LinearGradient(
    colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient phase3Gradient = LinearGradient(
    colors: [Color(0xFFE91E63), Color(0xFFF44336)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
