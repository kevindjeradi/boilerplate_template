import 'package:flutter/material.dart';

/// A generic widget that switches between mobile and desktop layouts
/// based on screen width using the desktopBreakpoint (1024px).
class LayoutSwitcher extends StatelessWidget {
  /// Widget to display on mobile screens (<1024px)
  final Widget mobile;

  /// Widget to display on desktop screens (>=1024px)
  final Widget desktop;

  /// Optional custom breakpoint (defaults to 1024px)
  final double? breakpoint;

  const LayoutSwitcher({
    super.key,
    required this.mobile,
    required this.desktop,
    this.breakpoint,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveBreakpoint = breakpoint ?? 1024.0;

        if (constraints.maxWidth < effectiveBreakpoint) {
          return mobile;
        } else {
          return desktop;
        }
      },
    );
  }
}
