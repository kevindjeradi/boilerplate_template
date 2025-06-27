import 'package:boilerplate_template/home_screen_desktop.dart';
import 'package:boilerplate_template/home_screen_mobile.dart';
import 'package:boilerplate_template/shared/widgets/layout_switcher.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LayoutSwitcher(
      mobile: HomeScreenMobile(),
      desktop: HomeScreenDesktop(),
    );
  }
}
