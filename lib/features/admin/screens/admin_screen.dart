import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/admin_controller.dart';
import '../screens/admin_dashboard_page.dart';
import '../screens/admin_users_page.dart';
import '../screens/admin_tests_page.dart';
import '../../../shared/widgets/layout_switcher.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutSwitcher(
      mobile: _AdminScreenMobile(),
      desktop: _AdminScreenDesktop(),
    );
  }
}

// Mobile - TabBar horizontale (optimal pour mobile)
class _AdminScreenMobile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPageIndex = ref.watch(adminControllerProvider);
    const adminPages = AdminPage.values;

    return DefaultTabController(
      length: adminPages.length,
      initialIndex: currentPageIndex,
      child: Column(
        children: [
          // Navigation tabs for admin sub-pages
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              onTap: (index) {
                ref.read(adminControllerProvider.notifier).setPageIndex(index);
              },
              tabs: adminPages.map((page) {
                IconData icon;
                switch (page) {
                  case AdminPage.dashboard:
                    icon = Icons.dashboard;
                    break;
                  case AdminPage.users:
                    icon = Icons.people;
                    break;
                  case AdminPage.tests:
                    icon = Icons.bug_report;
                    break;
                }
                return Tab(
                  icon: Icon(icon),
                  text: page.title,
                );
              }).toList(),
            ),
          ),
          // Content
          const Expanded(
            child: TabBarView(
              children: [
                AdminDashboardPage(),
                AdminUsersPage(),
                AdminTestsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Desktop - NavigationRail vertical (évite le double menu horizontal)
class _AdminScreenDesktop extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPageIndex = ref.watch(adminControllerProvider);
    const adminPages = AdminPage.values;

    const pages = [
      AdminDashboardPage(),
      AdminUsersPage(),
      AdminTestsPage(),
    ];

    return Row(
      children: [
        // NavigationRail vertical
        NavigationRail(
          selectedIndex: currentPageIndex,
          onDestinationSelected: (index) {
            ref.read(adminControllerProvider.notifier).setPageIndex(index);
          },
          labelType: NavigationRailLabelType.all,
          destinations: adminPages.map((page) {
            IconData icon;
            switch (page) {
              case AdminPage.dashboard:
                icon = Icons.dashboard;
                break;
              case AdminPage.users:
                icon = Icons.people;
                break;
              case AdminPage.tests:
                icon = Icons.bug_report;
                break;
            }
            return NavigationRailDestination(
              icon: Icon(icon),
              label: Text(page.title),
            );
          }).toList(),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        // Contenu principal
        Expanded(
          child: pages[currentPageIndex],
        ),
      ],
    );
  }
}
