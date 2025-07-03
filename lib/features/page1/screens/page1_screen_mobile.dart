import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/content_card.dart';

class Page1ScreenMobile extends ConsumerWidget {
  const Page1ScreenMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ContentCard(
      icon: Icons.article_rounded,
      title: 'Page 1',
      subtitle: 'Première page d\'exemple de votre boilerplate',
      isDesktop: false,
    );
  }
}
