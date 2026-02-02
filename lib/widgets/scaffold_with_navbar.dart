import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:sham_cars/features/home/components/custom_drawer.dart';

import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/app_name.dart';

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
        title: const SizedBox(width: 140, child: AppName()),
        centerTitle: true,
      ),
      body: navigationShell, // The current active branch's content
      drawer: const CustomDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta),
            label: 'Vehicles',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}
