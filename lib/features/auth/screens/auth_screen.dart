import 'package:boilerplate_template/shared/widgets/layout_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_screen_desktop.dart';
import 'auth_screen_mobile.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const LayoutSwitcher(
      mobile: AuthScreenMobile(),
      desktop: AuthScreenDesktop(),
    );
  }
}
