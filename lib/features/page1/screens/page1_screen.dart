import 'package:flutter/material.dart';

import 'page1_screen_mobile.dart';
import 'page1_screen_desktop.dart';
import '../../../shared/widgets/layout_switcher.dart';

class Page1Screen extends StatelessWidget {
  const Page1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LayoutSwitcher(
      mobile: Page1ScreenMobile(),
      desktop: Page1ScreenDesktop(),
    );
  }
}
