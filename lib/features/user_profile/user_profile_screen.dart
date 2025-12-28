import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/theme/app_theme.dart';
import 'package:sham_cars/features/user/models.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/dialogs/error_dialog.dart';
import 'package:sham_cars/widgets/page_loader.dart';

import 'cubit/user_profile_cubit.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});
  String getAboutUserMessage(User? user) {
    if (user == null) return "";
    return "You're signed in as ${user.fullName}";
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 10);
    final user = GetIt.I.get<AuthNotifier>().currentUser;

    return BlocProvider(
      create: (context) => UserProfileCubit(user),
      child: BlocListener<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state.isBusy) {
            PageLoader.of(context).show();
          } else {
            PageLoader.of(context).hide();
          }
          if (state is LogoutFailureState) {
            showErrorDialog(
              context,
              title: context.l10n.logoutFailureDialogTitle,
              errMessage: state.appErr.getMessage(context),
            );
          }
        },
        child: Column(
          children: [
            ListTile(
              dense: true,
              title: Text(context.l10n.publicProfileSettingsTileLabel),
            ),
            ListTile(
              title: Text(
                user?.fullName != null
                    ? context.l10n.signedInAs
                    : context.l10n.signedInWith,
              ),
              subtitle: Text(
                user?.fullName ?? user?.phoneNumber ?? user?.email ?? "",
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.primary,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
            gap,
            ListTile(
              dense: true,
              title: Text(context.l10n.accountSettingsTileLabel),
            ),
            gap,
            _CustomListTile(
              title: context.l10n.changePasswordBtnLabel,
              icon: Icons.lock_outline_rounded,
              onTap: context.read<UserProfileCubit>().onChangePasswordRequested,
            ),
            gap,
            _CustomListTile(
              title: context.l10n.logoutBtnLabel,
              icon: Icons.logout,
              onTap: context.read<UserProfileCubit>().onLogoutRequested,
            ),
            gap,
            gap,
            _CustomListTile(
              title: context.l10n.deleteAccountBtnLabel,
              icon: Icons.delete_forever,
              onTap: context.read<UserProfileCubit>().onDeleteAccountRequested,
              textColor: AppTheme.redColor,
              iconColor: AppTheme.redColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textColor: textColor,
      iconColor: iconColor ?? context.colorScheme.primary,
      title: Text(title),
      leading: Icon(icon),
      trailing: Icon(
        Icons.chevron_right,
        color: iconColor ?? context.colorScheme.primary,
      ),
      tileColor: context.colorScheme.inversePrimary,
    );
  }
}
