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

class AddReviewSheet extends StatefulWidget {
  const AddReviewSheet({
    super.key,
    this.preselectedTrimId,
    this.preselectedTrimTitle,
    this.lockTrim = false,
  });

  final int? preselectedTrimId;
  final String? preselectedTrimTitle;
  final bool lockTrim;

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  int _rating = 5;
  String? _cityCode;

  int? _trimId;
  String? _trimTitle;

  static const _cities = [
    ('damascus', 'دمشق'),
    ('aleppo', 'حلب'),
    ('homs', 'حمص'),
    ('hama', 'حماة'),
    ('latakia', 'اللاذقية'),
    ('tartus', 'طرطوس'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.preselectedTrimId != null) {
      _trimId = widget.preselectedTrimId;
      _trimTitle =
          widget.preselectedTrimTitle ?? 'النسخة #${widget.preselectedTrimId}';
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
      builder: (_) => BlocProvider(
        create: (c) => TrimPickerCubit(c.read<CarDataRepository>()),
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
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return Padding(
            padding: EdgeInsets.only(
              left: ThemeConstants.p,
              right: ThemeConstants.p,
              top: ThemeConstants.p,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom + ThemeConstants.p,
            ),
            child: Form(
              key: _formKey,
              child: ListenableBuilder(
                listenable: GetIt.I.get<AuthNotifier>(),
                builder: (context, _) {
                  final auth = GetIt.I.get<AuthNotifier>();

                  return BlocBuilder<
                    CommunityActionsCubit,
                    CommunityActionsState
                  >(
                    builder: (context, actionState) {
                      return ListView(
                        controller: scrollController,
                        children: [
                          // Handle
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: cs.outlineVariant,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          // Header
                          Text(
                            'أضف تجربتك',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'شارك تجربتك مع السيارة لمساعدة الآخرين',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                          const SizedBox(height: 20),

                          // Auth warning
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
                                      'يجب تسجيل الدخول لإضافة تجربة',
                                      style: TextStyle(
                                        color: cs.onErrorContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Trim field (locked or pickable)
                          _TrimField(
                            title: _trimTitle,
                            locked: widget.lockTrim,
                            onPick: _pickTrim,
                          ),
                          const SizedBox(height: 16),

                          // Rating
                          Text(
                            'التقييم *',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          _RatingSelector(
                            value: _rating,
                            onChanged: (r) => setState(() => _rating = r),
                          ),
                          const SizedBox(height: 16),

                          // City
                          DropdownButtonFormField<String>(
                            initialValue: _cityCode,
                            decoration: InputDecoration(
                              enabled: auth.isLoggedIn,
                              labelText: 'المدينة (اختياري)',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.location_city),
                            ),
                            items: _cities
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c.$1,
                                    child: Text(c.$2),
                                  ),
                                )
                                .toList(),
                            onChanged: (c) => setState(() => _cityCode = c),
                          ),
                          const SizedBox(height: 16),

                          // Title
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              enabled: auth.isLoggedIn,
                              labelText: 'عنوان التجربة (اختياري)',
                              hintText:
                                  'مثال: تجربة رائعة بعد سنة من الاستخدام',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Body
                          TextFormField(
                            controller: _bodyController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              enabled: auth.isLoggedIn,
                              labelText: 'تفاصيل التجربة *',
                              hintText: 'اكتب عن تجربتك مع السيارة...',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'الرجاء كتابة تفاصيل التجربة';
                              }
                              if (v.trim().length < 30) {
                                return 'التفاصيل قصيرة جداً (30 حرف على الأقل)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          if (actionState.submitError != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: cs.errorContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                actionState.submitError!,
                                style: TextStyle(color: cs.onErrorContainer),
                              ),
                            ),

                          FilledButton(
                            onPressed:
                                (!auth.isLoggedIn || actionState.isSubmitting)
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    if (_trimId == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('الرجاء اختيار النسخة'),
                                        ),
                                      );
                                      return;
                                    }

                                    final ok = await context
                                        .read<CommunityActionsCubit>()
                                        .submitReview(
                                          carTrimId: _trimId!,
                                          rating: _rating,
                                          comment: _bodyController.text.trim(),
                                          title:
                                              _titleController.text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : _titleController.text.trim(),
                                          cityCode: _cityCode,
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
                                : const Text('نشر التجربة'),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
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

    if (locked) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'السيارة (النسخة)',
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
        decoration: const InputDecoration(
          labelText: 'السيارة (النسخة) *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.directions_car_sharp),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title ?? 'اضغط للاختيار')),
            Icon(Icons.expand_more, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _RatingSelector extends StatelessWidget {
  const _RatingSelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final rating = i + 1;
        final isSelected = rating <= value;
        return IconButton(
          onPressed: () => onChanged(rating),
          icon: Icon(
            isSelected ? Icons.star : Icons.star_border,
            color: isSelected ? Colors.amber : null,
            size: 36,
          ),
        );
      }),
    );
  }
}
