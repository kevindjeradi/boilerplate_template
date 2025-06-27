import 'package:boilerplate_template/features/settings/screens/settings_screen_desktop.dart';
import 'package:boilerplate_template/features/settings/screens/settings_screen_mobile.dart';
import 'package:boilerplate_template/shared/widgets/layout_switcher.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LayoutSwitcher(
      mobile: SettingsScreenMobile(),
      desktop: SettingsScreenDesktop(),
    );
  }
}
