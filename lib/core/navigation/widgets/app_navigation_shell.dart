import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/layout_switcher.dart';
import 'mobile_navigation_shell.dart';
import 'desktop_navigation_shell.dart';

class AppNavigationShell extends ConsumerWidget {
  const AppNavigationShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutSwitcher(
      mobile: MobileNavigationShell(
        currentIndex: navigationShell.currentIndex,
        onIndexChanged: (index) => navigationShell.goBranch(index),
        pages: [navigationShell],
      ),
      desktop: DesktopNavigationShell(
        currentIndex: navigationShell.currentIndex,
        onIndexChanged: (index) => navigationShell.goBranch(index),
        pages: [navigationShell],
      ),
    );
  }
}
