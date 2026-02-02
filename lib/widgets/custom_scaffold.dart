import 'package:flutter/material.dart';
import 'package:sham_cars/features/home/components/custom_drawer.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/app_name.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    this.bodyPadding,
    this.appBarActions,
    this.title,
    this.showBackButton = true,
    required this.body,
    this.showOptionsActionBtn = true,
  });
  final Widget body;
  final EdgeInsets? bodyPadding;
  final List<Widget>? appBarActions;
  final String? title;
  final bool showBackButton;
  final bool showOptionsActionBtn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        surfaceTintColor: context.colorScheme.surface,
        centerTitle: true,
        actions: [...(appBarActions != null ? appBarActions! : [])],
        title: const SizedBox(width: 130, child: AppName()),
      ),
      body: SafeArea(
        child: Padding(
          padding: bodyPadding ?? const EdgeInsets.all(12),
          child: body,
        ),
      ),
    );
  }
}
