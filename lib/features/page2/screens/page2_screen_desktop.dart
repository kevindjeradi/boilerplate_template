import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/content_card.dart';

class Page2ScreenDesktop extends ConsumerWidget {
  const Page2ScreenDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ContentCard(
      icon: Icons.description_rounded,
      title: 'Page 2',
      subtitle: 'Seconde page d\'exemple de votre boilerplate',
      isDesktop: true,
    );
  }
}
