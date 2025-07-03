import 'package:flutter/material.dart';

import 'page2_screen_mobile.dart';
import 'page2_screen_desktop.dart';
import '../../../shared/widgets/layout_switcher.dart';

class Page2Screen extends StatelessWidget {
  const Page2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LayoutSwitcher(
      mobile: Page2ScreenMobile(),
      desktop: Page2ScreenDesktop(),
    );
  }
}
