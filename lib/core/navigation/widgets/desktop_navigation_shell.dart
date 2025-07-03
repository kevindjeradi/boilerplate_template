import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'desktop_header_navigation.dart';

class DesktopNavigationShell extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<Widget> pages;

  const DesktopNavigationShell({
    required this.currentIndex,
    required this.onIndexChanged,
    required this.pages,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: DesktopHeaderNavigation(
        currentIndex: currentIndex,
        onIndexChanged: onIndexChanged,
      ),
      body: pages.first, // Le navigationShell est le premier (et seul) élément
    );
  }
}
