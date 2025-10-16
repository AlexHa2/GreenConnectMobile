import 'package:flutter/material.dart';

/// Light theme color palette
class AppColors {
  // ===== Core Backgrounds =====
  static const Color background = Color(0xFFFFFFFF); // Main app background
  static const Color surface = Color(
    0xFFFFFFFF,
  ); // Surface elements (cards, sheets)

  // ===== Brand & Status Colors =====
  static const Color primary = Color(0xFF21BC5A); // Brand primary green
  static const Color warning = Color(0xFFFFD83D); // Warning or alert color
  static const Color danger = Color(0xFFC72323); // Error or destructive color

  // ===== Borders & Inputs =====
  static const Color border = Color(0xFFEEEEEE); // Light gray border
  static const Color inputBackground = Color(
    0xFFF5F5F5,
  ); // Input field background

  // ===== Text Colors =====
  static const Color textPrimary = Color(
    0xFF000000,
  ); // Primary text (titles, main content)
  static const Color textSecondary = Color(
    0xFF738C80,
  ); // Secondary text (hints, subtitles)

  // ===== Gradients =====
  static const LinearGradient linearPrimary = LinearGradient(
    colors: [Color(0xFF29C562), Color(0xFF70D194)],
    stops: [0.60, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient linearSecondary = LinearGradient(
    colors: [Color(0xFFF3F3D4), Color(0xFFD6F0D8)],
    stops: [0.0, 0.7],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Dark theme color palette
class AppColorsDark {
  // ===== Core Backgrounds =====
  static const Color background = Color(0xFF121212); // Main dark background
  static const Color surface = Color(0xFF1E1E1E); // Cards, dialogs, app bars

  // ===== Borders & Inputs =====
  static const Color border = Color(0xFF333333); // Subtle border for dark UI
  static const Color inputBackground = Color(
    0xFF2C2C2C,
  ); // Input field background

  // ===== Text Colors =====
  static const Color textPrimary = Color(0xFFEFEFEF); // Main readable text
  static const Color textSecondary = Color(
    0xFF9FBBAF,
  ); // Secondary descriptive text
  static const Color textHint = Color(0xFF7A8B80); // Placeholder / hint text

  // ===== Brand & Status Colors =====
  static const Color primary = Color(0xFF21BC5A); // Brand green (same as light)
  static const Color warning = Color(0xFFFFD83D); // Alert or caution
  static const Color danger = Color(0xFFC72323); // Error or destructive color

  // ===== Gradients =====
  static const LinearGradient linearPrimary = LinearGradient(
    colors: [Color(0xFF29C562), Color(0xFF70D194)],
    stops: [0.60, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient linearSecondary = LinearGradient(
    colors: [Color(0xFFF3F3D4), Color(0xFFD6F0D8)],
    stops: [0.0, 0.7],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
