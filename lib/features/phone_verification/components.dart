part of 'phone_verification_screen.dart';


class _ResendCodeSection extends StatelessWidget {
  const _ResendCodeSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PhoneVerificationCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: OverflowBar(
        alignment: MainAxisAlignment.start,
        children: [
          Text(context.l10n.didNotReceiveCode),
          BlocBuilder<PhoneVerificationCubit, PhoneVerificationState>(
            buildWhen: (prev, current) =>
                prev.canRequestNewCode() != current.canRequestNewCode(),
            builder: (context, state) {
              return state.canRequestNewCode()
                  ? TextButton(
                      onPressed: cubit.onNewCodeRequested,
                      child: Text(context.l10n.resendVerificationCodeBtnLabel),
                    )
                  : Text(
                      context.l10n.resendVerificationCodeIn,
                      style: context.myTxtTheme.bodyMedium,
                    );
            },
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PhoneVerificationCubit>();
    return BlocBuilder<PhoneVerificationCubit, PhoneVerificationState>(
      buildWhen: (prev, current) =>
          prev.inputIsValid() != current.inputIsValid(),
      builder: (context, state) => FilledButton(
        onPressed: () {
          if (state.inputIsValid()) {
            return () => cubit.onSubmitCode();
          }
          return null;
        }(),
        style: const ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size.fromHeight(48)),
        ),
        child: Text(context.l10n.verifyBtnLabel),
      ),
    );
  }
}

class _ChangeNumberSection extends StatelessWidget {
  const _ChangeNumberSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.l10n.wrongNumberToVerify,
          style: context.myTxtTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop(true);
            } else {
              pLogger.w(
                  '`SignupScreenRoute` is not present in the stack before `PhoneVerificationScreeRoute`');
            }
          },
          child: Text(context.l10n.changeNumberToVerify),
        )
      ],
    );
  }
}

class _PhoneVerificationScaffold extends StatelessWidget {
  const _PhoneVerificationScaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneVerificationCubit, PhoneVerificationState>(
      listener: (context, state) {
        switch (state) {
          case PhoneVerificationSuccessState():
            // context.read<SignupCubit>().proceedToSecondStep();
            // context.pop(true);
            break;
          case PhoneVerificationFailureState errState:
            showErrorDialog(
              context,
              title: context.l10n.phoneVerificationErrorDialogTitle,
              errMessage: errState.appException.getMessage(context),
            );
            break;
          default:
            break;
        }
      },
      builder: (context, state) => CustomScaffold(
        showBackButton: false,
        showLoadingBarrier: state is PhoneVerificationInProgressState ||
            state is PhoneVerificationSuccessState,
        bodyPadding: EdgeInsets.zero,
        body: child,
      ),
    );
  }
}
