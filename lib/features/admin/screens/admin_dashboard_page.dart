import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.marginMedium,
        children: [
          // En-tête de la page
          Card(
            child: Padding(
              padding: EdgeInsets.all(context.paddingMedium),
              child: Column(
                spacing: context.marginSmall,
                children: [
                  const Icon(Icons.dashboard, size: 48, color: Colors.blue),
                  Text(
                    'Tableau de bord',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Vue d\'ensemble de l\'administration',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Contenu vide pour l'instant
          Card(
            child: Padding(
              padding: EdgeInsets.all(context.paddingMedium),
              child: Column(
                spacing: context.marginSmall,
                children: [
                  const Icon(Icons.construction, size: 64, color: Colors.grey),
                  Text(
                    'En cours de développement',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Cette page sera bientôt disponible avec des statistiques et des informations importantes.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
