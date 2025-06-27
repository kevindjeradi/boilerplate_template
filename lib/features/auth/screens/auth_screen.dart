import 'package:boilerplate_template/features/auth/screens/auth_screen_desktop.dart';
import 'package:boilerplate_template/features/auth/screens/auth_screen_mobile.dart';
import 'package:boilerplate_template/shared/widgets/layout_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutSwitcher(
      mobile: AuthScreenMobile(),
      desktop: AuthScreenDesktop(),
    );
  }
}
