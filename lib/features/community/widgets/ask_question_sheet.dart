import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/community/cubits/community_actions_cubit.dart';
import 'package:sham_cars/features/community/cubits/trim_picker_cubit.dart';
import 'package:sham_cars/features/community/widgets/trim_picker_sheet.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/repositories/car_data_repository.dart';
import 'package:sham_cars/utils/utils.dart';

class AskQuestionSheet extends StatefulWidget {
  const AskQuestionSheet({
    super.key,
    this.preselectedTrimId,
    this.preselectedTrimTitle,
    this.lockTrim = false,
  });

  final int? preselectedTrimId;
  final String? preselectedTrimTitle;
  final bool lockTrim;

  @override
  State<AskQuestionSheet> createState() => _AskQuestionSheetState();
}

class _AskQuestionSheetState extends State<AskQuestionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  int? _trimId;
  String? _trimTitle;

  @override
  void initState() {
    super.initState();
    if (widget.preselectedTrimId != null) {
      _trimId = widget.preselectedTrimId;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.preselectedTrimId != null && _trimTitle == null) {
      _trimTitle =
          widget.preselectedTrimTitle ??
          context.l10n.sheetAskQuestionTrimFallback(widget.preselectedTrimId!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _pickTrim() async {
    final selected = await showModalBottomSheet<CarTrimSummary>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (c) => TrimPickerCubit(c.read<CarDataRepository>()),
          ),
        ],
        child: const TrimPickerSheet(),
      ),
    );

    if (selected != null) {
      setState(() {
        _trimId = selected.id;
        _trimTitle = selected.fullName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => CommunityActionsCubit(context.read()),
      child: Padding(
        padding: EdgeInsets.only(
          left: ThemeConstants.p,
          right: ThemeConstants.p,
          top: ThemeConstants.p,
          bottom: MediaQuery.of(context).viewInsets.bottom + ThemeConstants.p,
        ),
        child: Form(
          key: _formKey,
          child: ListenableBuilder(
            listenable: GetIt.I.get<AuthNotifier>(),
            builder: (context, _) {
              final auth = GetIt.I.get<AuthNotifier>();

              return BlocBuilder<CommunityActionsCubit, CommunityActionsState>(
                builder: (context, actionState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            context.l10n.sheetAskQuestionTitle,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (!auth.isLoggedIn) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cs.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: cs.onErrorContainer,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  context.l10n.authRequiredToPostQuestion,
                                  style: TextStyle(color: cs.onErrorContainer),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      _TrimField(
                        title: _trimTitle,
                        locked: widget.lockTrim,
                        onPick: _pickTrim,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          enabled: auth.isLoggedIn,
                          labelText: context.l10n.fieldQuestionTitleLabel,
                          hintText: context.l10n.fieldQuestionTitleHint,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) {
                                                    if (v == null || v.trim().isEmpty) {
                                                      return context.l10n.validationQuestionTitleRequired;
                                                    }
                                                    if (v.trim().length < 10) {
                                                      return context.l10n.validationQuestionTitleTooShort;
                                                    }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _bodyController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          enabled: auth.isLoggedIn,
                          labelText: context.l10n.fieldQuestionBodyLabel,
                          hintText: context.l10n.fieldQuestionBodyHint,
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return context.l10n.validationQuestionBodyRequired;
                          }
                          if (v.trim().length < 20) {
                            return context.l10n.validationQuestionBodyTooShort;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      if (actionState.submitError != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            actionState.submitError!,
                            style: TextStyle(color: cs.error),
                          ),
                        ),

                      FilledButton(
                        onPressed:
                            (!auth.isLoggedIn || actionState.isSubmitting)
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                if (_trimId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        context.l10n.validationSelectTrim,
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final ok = await context
                                    .read<CommunityActionsCubit>()
                                    .submitQuestion(
                                      carTrimId: _trimId!,
                                      title: _titleController.text.trim(),
                                      body: _bodyController.text.trim(),
                                    );

                                if (ok && context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              },
                        child: actionState.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(context.l10n.buttonPublishQuestion),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TrimField extends StatelessWidget {
  const _TrimField({
    required this.title,
    required this.locked,
    required this.onPick,
  });

  final String? title;
  final bool locked;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    if (locked) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.fieldTrimLabelOptional,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.directions_car_sharp),
        ),
        child: Text(title ?? '—', style: TextStyle(color: cs.onSurface)),
      );
    }

    return InkWell(
      onTap: onPick,
      borderRadius: ThemeConstants.cardRadius,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.fieldTrimLabelRequired,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.directions_car_sharp),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title ?? l10n.fieldTrimTapToSelect)),
            Icon(Icons.expand_more, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
