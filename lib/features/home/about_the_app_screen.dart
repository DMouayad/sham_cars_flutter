import 'package:flutter/material.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/custom_scaffold.dart';

class AboutTheAppScreen extends StatelessWidget {
  const AboutTheAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showLoadingBarrier: false,
      body: Column(
        children: [
          ListTile(
            dense: true,
            leading: const Icon(Icons.question_mark_outlined),
            style: ListTileStyle.drawer,
            title: Text(context.l10n.fAQTileLabel),
            onTap: () {},
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.support_agent_outlined),
            style: ListTileStyle.drawer,
            title: Text(context.l10n.contactUsTileLabel),
            onTap: () {},
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.policy_outlined),
            style: ListTileStyle.drawer,
            title: Text(context.l10n.termsTileLabel),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
