import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/content_card.dart';

class Page1ScreenDesktop extends ConsumerWidget {
  const Page1ScreenDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ContentCard(
      icon: Icons.article_rounded,
      title: 'Page 1',
      subtitle: 'Première page d\'exemple de votre boilerplate',
      isDesktop: true,
    );
  }
}
