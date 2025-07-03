import 'package:flutter/material.dart';

class NavigationItem {
  final String route;
  final IconData icon;
  final String label;

  const NavigationItem({
    required this.route,
    required this.icon,
    required this.label,
  });
}
