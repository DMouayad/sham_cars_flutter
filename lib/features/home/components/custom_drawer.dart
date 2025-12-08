import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sham_cars/l10n/app_localizations.dart';
import 'package:sham_cars/features/auth/cubit/auth_state_cubit.dart';
import 'package:sham_cars/features/auth/models/auth_state.dart';
import 'package:sham_cars/features/localization/cubit/localization_cubit.dart';
import 'package:sham_cars/features/theme/theme_cubit.dart';
import 'package:sham_cars/routes/routes.dart';
import 'package:sham_cars/utils/utils.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const divider = Divider(thickness: 2);
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 45, 25, 30),
              child: OverflowBar(
                alignment: MainAxisAlignment.start,
                spacing: 8,
                children: [
                  SvgPicture.asset('assets/images/logo.svg', height: 40),
                  Text(
                    context.l10n.appName,
                    textAlign: TextAlign.center,
                    style: context.myTxtTheme.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // divider,
          BlocBuilder<AuthStateCubit, AuthState>(
            builder: (context, state) {
              return state.user != null
                  ? ListTile(
                      leading: const Icon(Icons.person_outline),
                      style: ListTileStyle.drawer,
                      title: Text(context.l10n.drawerProfileIBtnLabel),
                      onTap: () => const UserProfileScreenRoute().push(context),
                    )
                  : ListTile(
                      iconColor: context.colorScheme.primary,
                      textColor: context.colorScheme.primary,
                      style: ListTileStyle.drawer,
                      title: Text(context.l10n.loginBtnLabel),
                      leading: const Icon(Icons.login_rounded),
                      onTap: () {
                        const LoginScreenRoute().push(context);
                      },
                    );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            style: ListTileStyle.drawer,
            title: Text(context.l10n.drawerAboutTheAppTile),
            onTap: () {},
          ),
          const Spacer(),

          divider,
          const _AppPrefsSection(),
        ],
      ),
    );
  }
}

class _AppPrefsSection extends StatelessWidget {
  const _AppPrefsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
      child: Column(
        children: [
          SwitchListTile.adaptive(
            dense: true,
            value: context.isDarkMode,
            title: Text(
              context.l10n.drawerDarkModeSwitchTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onChanged: (darkModeEnabled) {
              darkModeEnabled
                  ? context.read<ThemeCubit>().toggleDarkMode()
                  : context.read<ThemeCubit>().toggleLightMode();
            },
          ),
          const SizedBox(height: 10),
          const _LanguageTile(),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    return OverflowBar(
      spacing: 8,
      alignment: MainAxisAlignment.start,
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
          return RadioListTile<Locale>(
            value: locale,
            dense: true,
            groupValue: context.locale,
            title: Text(
              context.getLocaleFullName(locale.languageCode),
              style: context.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurface,
              ),
            ),
            selected: isSelected,
            onChanged: (locale) {
              if (locale == null) {
                return;
              }
              context.read<LocalizationCubit>().setLocale(locale);
            },
          );
        }),
      ],
    );
  }
}
