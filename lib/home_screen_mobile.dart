import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boilerplate_template/shared/widgets/content_card.dart';

class HomeScreenMobile extends ConsumerWidget {
  const HomeScreenMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    return ContentCard(
      icon: Icons.home_rounded,
      title: localization.welcome,
      subtitle: 'Bienvenue sur votre application',
      isDesktop: false,
    );
  }
}
