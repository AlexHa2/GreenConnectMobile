import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Light Theme
final ThemeData lightTheme = ThemeData(
  extensions: <ThemeExtension<dynamic>>[const AppSpacing(screenPadding: 12)],

  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,

  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onSurface: Colors.black,
  ),

  cardColor: AppColors.surface,
  dividerColor: AppColors.border,
  primaryColorDark: AppColors.textPrimary,
  primaryColorLight: AppColors.background,

  // ===== AppBar =====
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.surface,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  // ===== Text Theme =====
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
    titleLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: TextStyle(color: AppColors.textSecondary, fontSize: 12),
  ),

  // ===== Buttons =====
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.background,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 1.5),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  ),

  // ===== Cards =====
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 2,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.border),
    ),
  ),

  // ===== Inputs =====
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackground,
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
    hintStyle: TextStyle(color: AppColors.textSecondary),
  ),
);

/// Dark Theme
final ThemeData darkTheme = ThemeData(
  extensions: <ThemeExtension<dynamic>>[const AppSpacing(screenPadding: 12)],

  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    onSurface: Colors.white,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColorsDark.background,
  primaryColor: AppColorsDark.primary,
  cardColor: AppColorsDark.surface,
  dividerColor: AppColorsDark.border,

  primaryColorLight: AppColorsDark.textPrimary,
  primaryColorDark: AppColorsDark.background,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColorsDark.surface,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColorsDark.textPrimary),
    titleTextStyle: TextStyle(
      color: AppColorsDark.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColorsDark.textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColorsDark.textSecondary, fontSize: 14),
    titleLarge: TextStyle(
      color: AppColorsDark.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: TextStyle(color: AppColorsDark.textHint, fontSize: 12),
  ),

  // ===== Buttons =====
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColorsDark.primary,
      foregroundColor: AppColorsDark.textPrimary,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColorsDark.primary,
      side: const BorderSide(color: AppColorsDark.primary, width: 1.5),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColorsDark.primary,
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  ),

  cardTheme: CardThemeData(
    color: AppColorsDark.surface,
    elevation: 3,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColorsDark.border),
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColorsDark.inputBackground,
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColorsDark.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColorsDark.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColorsDark.primary, width: 1.5),
    ),
    hintStyle: TextStyle(color: AppColorsDark.textHint),
  ),
);
