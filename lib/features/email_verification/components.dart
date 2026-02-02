part of 'email_verification_screen.dart';

class _ResendCodeSection extends StatefulWidget {
  const _ResendCodeSection();

  @override
  State<_ResendCodeSection> createState() => _ResendCodeSectionState();
}

class _ResendCodeSectionState extends State<_ResendCodeSection> {
  Timer? _timer;
  Duration? _remainingTime;

  @override
  void initState() {
    super.initState();
    final state = context.read<EmailVerificationCubit>().state;
    if (!state.canRequestNewCode()) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    final cubit = context.read<EmailVerificationCubit>();
    final lastRequested = cubit.state.lastRequestedCodeAt;
    final endTime = lastRequested.add(kVerificationCodeRequestInterval);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(endTime)) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() {
          _remainingTime = endTime.difference(now);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '($minutes:$seconds)';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EmailVerificationCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: OverflowBar(
        alignment: MainAxisAlignment.start,
        children: [
          Text(context.l10n.didNotReceiveCode),
          BlocBuilder<EmailVerificationCubit, EmailVerificationState>(
            buildWhen: (prev, current) =>
                prev.canRequestNewCode() != current.canRequestNewCode(),
            builder: (context, state) {
              if (state.canRequestNewCode()) {
                _timer?.cancel();
                return TextButton(
                  onPressed: () {
                    cubit.onNewCodeRequested();
                    _startTimer();
                  },
                  child: Text(context.l10n.resendVerificationCodeBtnLabel),
                );
              } else {
                if (_remainingTime == null) {
                  // Calculate initial remaining time
                  final endTime = state.lastRequestedCodeAt.add(
                    kVerificationCodeRequestInterval,
                  );
                  _remainingTime = endTime.difference(DateTime.now());
                }
                return Text(
                  '${context.l10n.resendVerificationCodeIn} ${_remainingTime != null ? _formatDuration(_remainingTime!) : ''}',
                  style: context.myTxtTheme.bodyMedium,
                );
              }
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
    final cubit = context.read<EmailVerificationCubit>();
    return BlocBuilder<EmailVerificationCubit, EmailVerificationState>(
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

class _ChangeEmailSection extends StatelessWidget {
  const _ChangeEmailSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.l10n.wrongEmailToVerify,
          style: context.myTxtTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            LoginRoute().pushReplacement(context);
          },
          child: Text(context.l10n.changeEmailToVerify),
        ),
      ],
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailVerificationCubit, EmailVerificationState>(
      listener: (context, state) {
        if (state.isBusy || state is EmailVerificationInProgressState) {
          context.showLoader();
        } else {
          context.hideLoader();
        }
        switch (state) {
          case EmailVerificationSuccessState():
            const ProfileRoute().go(context);
            break;
          case EmailVerificationFailureState errState:
            showErrorDialog(
              context,
              title: context.l10n.emailVerificationErrorDialogTitle,
              errMessage: errState.appException.getMessage(context),
            );
            break;
          default:
            break;
        }
      },
      child: child,
    );
  }
}
