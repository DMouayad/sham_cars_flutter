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
    if (index == 3) {
      Scaffold.of(context).openEndDrawer();
    } else {
      // Navigate to the selected branch
      // GoRouter ensures the correct navigation state is restored
      navigationShell.goBranch(
        index,
        // Display the initial location when navigating to a new branch
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        surfaceTintColor: context.colorScheme.surface,
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,
        title: const SizedBox(width: 110, child: AppName()),
        centerTitle: true,
      ),
      body: navigationShell, // The current active branch's content
      // drawer: context.isRTL ? const CustomDrawer() : null,
      endDrawer: const CustomDrawer(),
      bottomNavigationBar: Builder(
        // use a `Builder` to be able to call [Scaffold.of(context)]
        builder: (context) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navigationShell.currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups_2_sharp),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'more'),
            ],
            onTap: (index) => _onTap(context, index),
          );
        },
      ),
    );
  }
}
