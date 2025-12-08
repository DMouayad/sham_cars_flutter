import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sham_cars/utils/utils.dart';

class CustomTitleAppbar extends StatelessWidget {
  const CustomTitleAppbar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            collapsedHeight: 90,
            expandedHeight: 250, // Adjust this value as needed
            floating: false,
            pinned: true,
            surfaceTintColor: context.theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.3,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 10,
                  spacing: 20,
                  runAlignment: WrapAlignment.end,
                  children: [
                    SvgPicture.asset('assets/images/logo.svg', height: 46),
                    Text(
                      context.l10n.appGreeting,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(child: child),
        ],
      ),
    );
  }
}
