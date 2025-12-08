import 'package:flutter/material.dart';
import 'package:sham_cars/routes/routes.dart';
import 'package:sham_cars/utils/utils.dart';

class HaveExistingAccountSection extends StatelessWidget {
  const HaveExistingAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.alreadyHaveAnAccountQuestion,
          style: context.textTheme.bodySmall,
        ),
        TextButton(
          onPressed: () => const LoginScreenRoute().pushReplacement(context),
          child: Text(context.l10n.loginBtnLabel),
        ),
      ],
    );
  }
}
