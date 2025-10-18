import 'package:flutter/material.dart';

class AppSpacing extends ThemeExtension<AppSpacing> {
  final double screenPadding;

  const AppSpacing({required this.screenPadding});

  @override
  AppSpacing copyWith({double? screenPadding}) =>
      AppSpacing(screenPadding: screenPadding ?? this.screenPadding);

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) => this;
}
