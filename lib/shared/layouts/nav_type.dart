import 'package:flutter/material.dart';

class NavConfig {
  final IconData icon;
  final String label;
  final String routeName;
  final Map<String, dynamic>? extra;

  const NavConfig({
    required this.icon,
    required this.label,
    required this.routeName,
    this.extra,
  });
}
