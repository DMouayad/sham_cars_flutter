import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/community/community_cubit.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class AddReviewSheet extends StatefulWidget {
  const AddReviewSheet({super.key, this.preselectedTrimId});

  final int? preselectedTrimId;

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  CarTrimSummary? _selectedTrim;
  int _rating = 5;
  String? _cityCode;

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
      // Find the CarTrimSummary from communityState.carTrims
      // This will be available after CommunityCubit loads, so we need a slight delay
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedTrim = context
              .read<CommunityCubit>()
              .state
              .carTrims
              .firstWhereOrNull((trim) => trim.id == widget.preselectedTrimId);
        });
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final communityState = context.watch<CommunityCubit>().state;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => Form(
        key: _formKey,

        child: ListenableBuilder(
          listenable: GetIt.I.get<AuthNotifier>(),
          builder: (context, _) {
            final authState = GetIt.I.get<AuthNotifier>();

            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(ThemeConstants.p),
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'شارك تجربتك مع السيارة لمساعدة الآخرين',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 24),

                // Auth warning
                if (!authState.isLoggedIn) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: cs.onErrorContainer),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'يجب تسجيل الدخول لإضافة تجربة',
                            style: TextStyle(color: cs.onErrorContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Trim picker
                DropdownButtonFormField<CarTrimSummary>(
                  initialValue: _selectedTrim,
                  decoration: const InputDecoration(
                    labelText: 'السيارة (النسخة) *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_car_sharp),
                  ),
                  items: communityState.carTrims.map((t) {
                    return DropdownMenuItem(value: t, child: Text(t.fullName));
                  }).toList(),
                  onChanged: (t) => setState(() => _selectedTrim = t),
                  validator: (v) => v == null ? 'الرجاء اختيار النسخة' : null,
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
                  decoration: const InputDecoration(
                    labelText: 'المدينة (اختياري)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  items: _cities.map((c) {
                    return DropdownMenuItem(value: c.$1, child: Text(c.$2));
                  }).toList(),
                  onChanged: (c) => setState(() => _cityCode = c),
                ),
                const SizedBox(height: 16),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان التجربة (اختياري)',
                    hintText: 'مثال: تجربة رائعة بعد سنة من الاستخدام',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Body
                TextFormField(
                  controller: _bodyController,
                  maxLines: 5,
                  decoration: const InputDecoration(
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
                const SizedBox(height: 16),

                // Error
                if (communityState.submitError case final err?)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      err,
                      style: TextStyle(color: cs.onErrorContainer),
                    ),
                  ),

                // Submit
                FilledButton(
                  onPressed:
                      authState.isLoggedIn && !communityState.isSubmitting
                      ? _submit
                      : null,
                  child: communityState.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('نشر التجربة'),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTrim == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء اختيار النسخة')));
      return;
    }

    final token = await GetIt.I.get<ITokensRepository>().get();
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يجب تسجيل الدخول لإضافة تجربة')),
        );
      }
      return;
    }

    final success = await context.read<CommunityCubit>().submitReview(
      carTrimId: _selectedTrim!.id,
      rating: _rating,
      comment: _bodyController.text.trim(),
      title: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      cityCode: _cityCode,
      accessToken: token,
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم نشر التجربة بنجاح')));
    }
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
