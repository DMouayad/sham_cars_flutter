import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sham_cars/l10n/app_localizations.dart';
import 'package:sham_cars/features/localization/cubit/localization_cubit.dart';
import 'package:sham_cars/features/theme/theme_cubit.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/app_name.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const divider = Divider(thickness: .8);
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),

        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppName(color: context.colorScheme.primary),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              style: ListTileStyle.drawer,
              title: Text(context.l10n.fAQTileLabel),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.mail_outline),
              style: ListTileStyle.drawer,
              title: Text(context.l10n.contactUsTileLabel),
              onTap: () {},
            ),
            divider,
            ListTile(
              leading: Icon(Icons.color_lens_outlined),
              title: Text('Appearance'),
            ),
            const _ThemeSettings(),
            const SizedBox(height: 10),
            const _LanguageTile(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ListTile(
          dense: true,
          title: Text(
            context.l10n.drawerLanguageBtnLabel,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ...AppLocalizations.supportedLocales.map((locale) {
          final isSelected = locale == context.locale;
          return ChoiceChip(
            onSelected: (_) =>
                context.read<LocalizationCubit>().setLocale(locale),
            selectedColor: context.colorScheme.primary,
            selected: isSelected,
            label: Text(context.getLocaleFullName(locale.languageCode)),
          );
        }),
      ],
    );
  }
}

class _ThemeSettings extends StatelessWidget {
  const _ThemeSettings();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ListTile(
          dense: true,
          title: Text(
            context.l10n.drawerThemeModeSwitchTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ...ThemeMode.values.map((themeMode) {
          final isSelected = themeMode == context.watch<ThemeCubit>().state;
          return ChoiceChip(
            selected: isSelected,
            selectedColor: context.colorScheme.primary,
            onSelected: (_) =>
                context.read<ThemeCubit>().setThemeMode(themeMode),
            label: Text(context.getThemeModeName(themeMode)),
          );
        }),
      ],
    );
  }
}
