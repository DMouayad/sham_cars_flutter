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

import 'support_overlays.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  bool showProfileTile(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    return !loc.startsWith(RoutePath.login);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final divider = Divider(thickness: .8, color: context.colorScheme.outline);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(child: AppName(color: cs.primary)),
            ),

            if (showProfileTile(context)) ...[
              const _UserProfileTile(),

              // Account links (depends on auth state)
              const _AccountSection(),
              divider,
            ],

            // Support
            _SectionLabel(title: context.l10n.drawerSupportSectionTitle),

            ListTile(
              leading: const Icon(Icons.help_outline_rounded),
              style: ListTileStyle.drawer,
              title: Text(context.l10n.supportFaqSectionTitle),
              onTap: () async {
                final rootCtx = Navigator.of(
                  context,
                  rootNavigator: true,
                ).context;
                Navigator.pop(context);
                await SupportOverlays.showFaq(rootCtx);
              },
            ),

            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              style: ListTileStyle.drawer,
              title: Text(context.l10n.supportContactSectionTitle),
              onTap: () async {
                final rootCtx = Navigator.of(
                  context,
                  rootNavigator: true,
                ).context;
                Navigator.pop(context);
                await SupportOverlays.showContact(rootCtx);
              },
            ),

            divider,

            // Preferences
            _SectionLabel(title: context.l10n.drawerPreferencesSectionTitle),
            const _ThemeSettings(),
            const SizedBox(height: 6),
            const _LanguageTile(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GetIt.I<AuthNotifier>(),
      builder: (context, _) {
        final divider = Divider(
          thickness: .8,
          color: context.colorScheme.outline,
        );

        final auth = GetIt.I<AuthNotifier>();
        final isLoggedIn = auth.isLoggedIn;

        if (isLoggedIn) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              divider,

              _SectionLabel(title: context.l10n.drawerAccountSectionTitle),
              ListTile(
                leading: const Icon(Icons.insights_outlined),
                style: ListTileStyle.drawer,
                title: Text(context.l10n.drawerMyActivityTileLabel),
                onTap: () {
                  Navigator.pop(context);
                  const ProfileActivityRoute().push(context);
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8, top: 8, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w800,
          fontSize: 12,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
            Navigator.pop(context);
            const ProfileRoute().push(context);
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
    return ExpansionTile(
      leading: const Icon(Icons.language_outlined, size: 18),
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        context.l10n.drawerLanguageBtnLabel,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      childrenPadding: const EdgeInsetsDirectional.only(
        start: 8,
        end: 8,
        bottom: 8,
      ),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
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
        ),
      ],
    );
  }
}

class _ThemeSettings extends StatelessWidget {
  const _ThemeSettings();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.color_lens_outlined, size: 18),
      title: Text(
        context.l10n.drawerAppearanceTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      childrenPadding: const EdgeInsetsDirectional.only(
        start: 8,
        end: 8,
        bottom: 8,
      ),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
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
        ),
      ],
    );
  }
}
