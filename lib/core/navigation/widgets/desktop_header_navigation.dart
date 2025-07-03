import 'package:boilerplate_template/core/navigation/config/navigation_config.dart';
import 'package:boilerplate_template/core/navigation/models/navigation_item.dart';
import 'package:boilerplate_template/core/router/app_router.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/features/auth/states/auth_state.dart';
import 'package:boilerplate_template/features/settings/widgets/theme_switch.dart';
import 'package:boilerplate_template/features/settings/widgets/language_picker.dart';
import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';
import 'package:boilerplate_template/shared/widgets/sign_out_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DesktopHeaderNavigation extends ConsumerWidget
    implements PreferredSizeWidget {
  const DesktopHeaderNavigation({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final authState = ref.watch(authControllerProvider);

    final isAuthenticated = authState is AuthAuthenticated;
    final isAdmin = currentUser?.role.isAdmin ?? false;

    final navigationTabs = NavigationConfig.getTabsForUser(
      localizations: localization,
      isAuthenticated: isAuthenticated,
      isAdmin: isAdmin,
    );

    return AppBar(
      title: Row(
        spacing: 32,
        children: [
          ...navigationTabs.asMap().entries.map((entry) {
            final displayIndex = entry.key;
            final tab = entry.value;
            final realIndex = _getRealIndex(displayIndex, navigationTabs);
            final isActive = realIndex == currentIndex;

            return TextButton.icon(
              onPressed: () => onIndexChanged(realIndex),
              icon: Icon(
                tab.icon,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              label: Text(
                tab.label,
                style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }),
        ],
      ),
      actions: [
        // Settings/Profile dropdown menu
        PopupMenuButton<String>(
          icon: Icon(isAuthenticated ? Icons.settings : Icons.person),
          tooltip: isAuthenticated ? localization.settings : 'Profile',
          offset: const Offset(0, kToolbarHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.borderRadiusSmall),
          ),
          itemBuilder: (context) => [
            // Auth section en premier si pas connecté
            if (!isAuthenticated)
              PopupMenuItem<String>(
                child: ListTile(
                  leading: const Icon(Icons.login),
                  title: Text(localization.accessAllFeatures),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.of(context).pop(); // Fermer le menu
                    AppNavigation.goToAuth(context);
                  },
                ),
              ),

            // Divider si login affiché
            if (!isAuthenticated)
              const PopupMenuItem<String>(
                enabled: false,
                child: Divider(),
              ),

            // Theme switch
            const PopupMenuItem<String>(
              enabled: false,
              child: Column(
                children: [
                  ThemeSwitch(),
                  Divider(),
                ],
              ),
            ),
            // Language picker
            const PopupMenuItem<String>(
              enabled: false,
              child: Column(
                children: [
                  LanguagePicker(),
                  Divider(),
                ],
              ),
            ),
            // Sign out si connecté
            if (isAuthenticated)
              const PopupMenuItem<String>(
                enabled: false,
                child: SignOutButton(),
              ),
          ],
        ),
      ],
    );
  }

  // Convertir l'index d'affichage vers l'index réel du shell
  int _getRealIndex(int displayIndex, List<NavigationItem> visibleTabs) {
    if (displayIndex >= visibleTabs.length) return 0;

    final selectedRoute = visibleTabs[displayIndex].route;
    final allTabs = ['/home', '/page1', '/page2', '/admin'];
    return allTabs.indexOf(selectedRoute);
  }
}
