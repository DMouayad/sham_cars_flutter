import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:sham_cars/features/home/widgets/custom_drawer.dart';
import 'package:sham_cars/router/routes.dart';

import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/app_name.dart';

const navigationShellIndex = (explore: 0, vehicles: 1, community: 2);

class ScaffoldWithNavBar extends StatelessWidget {
  // The navigation shell and container for the branch Navigators
  final StatefulNavigationShell navigationShell;
  final String title;
  final bool showBackButton;

  const ScaffoldWithNavBar({
    super.key,
    this.showBackButton = true,
    required this.title,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    // Navigate to the selected branch
    navigationShell.goBranch(
      index,
      // Display the initial location when navigating to a new branch
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        surfaceTintColor: context.colorScheme.surface,
        title: InkWell(
          onTap: () => context.go(RoutePath.home),
          child: const SizedBox(width: 140, child: AppName()),
        ),
        actions: [
          IconButton(
            onPressed: () => const ProfileActivityRoute().push(context),
            icon: const Icon(Icons.person),
          ),
        ],
        centerTitle: true,
      ),
      body: navigationShell, // The current active branch's content
      drawer: const CustomDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore_outlined),
            label: context.l10n.navbarExploreLabel,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.drive_eta),
            label: context.l10n.navbarVehiclesLabel,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: context.l10n.navbarCommunityLabel,
          ),
        ],
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}
