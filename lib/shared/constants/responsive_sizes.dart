import 'package:flutter/material.dart';

/// Extension to provide responsive sizes based on screen type
extension ResponsiveSizes on BuildContext {
  /// Breakpoint for responsive design
  static const double _desktopBreakpoint = 1024.0;

  /// Check if current screen is mobile
  bool get isMobile => MediaQuery.of(this).size.width < _desktopBreakpoint;

  /// Check if current screen is desktop
  bool get isDesktop => MediaQuery.of(this).size.width >= _desktopBreakpoint;

  // Responsive margins
  double get marginSmall => isMobile ? 8.0 : 12.0;
  double get marginMedium => isMobile ? 16.0 : 24.0;
  double get marginLarge => isMobile ? 24.0 : 48.0;

  // Responsive padding
  double get paddingSmall => isMobile ? 8.0 : 12.0;
  double get paddingMedium => isMobile ? 16.0 : 24.0;
  double get paddingLarge => isMobile ? 24.0 : 48.0;

  // Responsive text sizes
  double get textSmall => isMobile ? 12.0 : 14.4;
  double get textMedium => isMobile ? 16.0 : 19.2;
  double get textLarge => isMobile ? 20.0 : 26.0;
  double get textExtraLarge => isMobile ? 24.0 : 31.2;

  // Responsive component sizes
  double get buttonHeight => isMobile ? 48.0 : 57.6;
  double get inputHeight => isMobile ? 50.0 : 60.0;

  // Responsive icon sizes
  double get iconSizeSmall => isMobile ? 20.0 : 26.0;
  double get iconSizeMedium => isMobile ? 40.0 : 52.0;
  double get iconSizeLarge => isMobile ? 60.0 : 78.0;

  // Responsive border radius
  double get borderRadiusSmall => isMobile ? 10.0 : 12.0;
  double get borderRadiusMedium => isMobile ? 20.0 : 24.0;
  double get borderRadiusLarge => isMobile ? 30.0 : 36.0;

  // Content width constraints for desktop
  double get maxContentWidth => isDesktop ? 800.0 : double.infinity;

  // Container constraints
  BoxConstraints get contentConstraints =>
      BoxConstraints(maxWidth: maxContentWidth);

  // Responsive EdgeInsets helpers
  EdgeInsets get paddingSmallAll => EdgeInsets.all(paddingSmall);
  EdgeInsets get paddingMediumAll => EdgeInsets.all(paddingMedium);
  EdgeInsets get paddingLargeAll => EdgeInsets.all(paddingLarge);

  EdgeInsets get paddingHorizontalSmall =>
      EdgeInsets.symmetric(horizontal: paddingSmall);
  EdgeInsets get paddingHorizontalMedium =>
      EdgeInsets.symmetric(horizontal: paddingMedium);
  EdgeInsets get paddingHorizontalLarge =>
      EdgeInsets.symmetric(horizontal: paddingLarge);

  EdgeInsets get paddingVerticalSmall =>
      EdgeInsets.symmetric(vertical: paddingSmall);
  EdgeInsets get paddingVerticalMedium =>
      EdgeInsets.symmetric(vertical: paddingMedium);
  EdgeInsets get paddingVerticalLarge =>
      EdgeInsets.symmetric(vertical: paddingLarge);

  // SizedBox helpers
  SizedBox get gapSmall => SizedBox(height: marginSmall);
  SizedBox get gapMedium => SizedBox(height: marginMedium);
  SizedBox get gapLarge => SizedBox(height: marginLarge);

  SizedBox get gapHorizontalSmall => SizedBox(width: marginSmall);
  SizedBox get gapHorizontalMedium => SizedBox(width: marginMedium);
  SizedBox get gapHorizontalLarge => SizedBox(width: marginLarge);
}
