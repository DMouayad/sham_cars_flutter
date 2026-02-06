import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/l10n/app_localizations.dart';
import 'package:sham_cars/features/localization/cubit/localization_cubit.dart';
import 'package:sham_cars/features/theme/theme_cubit.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/app_name.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  bool showProfileTile(BuildContext context) {
    final String currentLocation = GoRouterState.of(context).uri.toString();

    if (currentLocation.startsWith(RoutePath.login)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    const divider = Divider(thickness: .8);
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: AppName(color: context.colorScheme.primary),
            ),
            if (showProfileTile(context)) ...[
              const _UserProfileTile(),
              divider,
            ],
            Flexible(
              child: ListView(
                children: [
                  // ------------------------
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
                    leading: const Icon(Icons.color_lens_outlined, size: 18),
                    title: Text(context.l10n.drawerAppearanceTitle),
                    dense: true,
                  ),
                  const _ThemeSettings(),
                  const SizedBox(height: 10),
                  const _LanguageTile(),
                ],
              ),
            ),
            // const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _UserProfileTile extends StatelessWidget {
  const _UserProfileTile();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GetIt.I<AuthNotifier>(),
      builder: (context, _) {
        final authNotifier = GetIt.I<AuthNotifier>();
        final isLoggedIn = authNotifier.isLoggedIn;

        final userName = isLoggedIn
            ? authNotifier.currentUser!.fullName
            : context.l10n.userGuestTitle;

        final userEmail = isLoggedIn
            ? authNotifier.currentUser!.email
            : context.l10n.userGuestSubtitle;

        return ListTile(
          // isThreeLine: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          leading: CircleAvatar(
            backgroundColor: context.colorScheme.primaryContainer,
            child: Icon(
              isLoggedIn ? Icons.person : Icons.person_outline,
              color: context.colorScheme.primary,
            ),
          ),
          title: Text(
            userName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            userEmail,
            style: TextStyle(
              fontSize: 12,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          onTap: () {
            Navigator.pop(context); // 1. Close the drawer first

            if (context.mounted) {
              const ProfileRoute().push(context);
            }
          },
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        );
      },
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
