import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contrôleur pour gérer la navigation entre les pages d'administration
class AdminController extends StateNotifier<int> {
  AdminController() : super(0); // Page index initial (Dashboard)

  /// Change l'index de la page d'administration courante
  void setPageIndex(int index) {
    state = index;
  }
}

/// Provider pour le contrôleur d'administration
final adminControllerProvider = StateNotifierProvider<AdminController, int>(
  (ref) => AdminController(),
);

/// Enum définissant les pages d'administration disponibles
enum AdminPage {
  dashboard('Tableau de bord', 'Vue d\'ensemble de l\'administration'),
  users('Utilisateurs', 'Gestion des utilisateurs'),
  tests('Tests', 'Tests des fonctionnalités');

  const AdminPage(this.title, this.description);

  final String title;
  final String description;
}
