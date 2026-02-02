import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/community/community_cubit.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class AskQuestionSheet extends StatefulWidget {
  const AskQuestionSheet({super.key});

  @override
  State<AskQuestionSheet> createState() => _AskQuestionSheetState();
}

class _AskQuestionSheetState extends State<AskQuestionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  CarModel? _selectedModel;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // final authState = context.watch<AuthCubit>().state;
    final questionsState = context.watch<CommunityCubit>().state;

    return Padding(
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
            final authNotifier = GetIt.I.get<AuthNotifier>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      'اطرح سؤالاً',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Auth warning
                if (!authNotifier.isLoggedIn) ...[
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
                            'يجب تسجيل الدخول لطرح سؤال',
                            style: TextStyle(color: cs.onErrorContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Model picker
                DropdownButtonFormField<CarModel>(
                  initialValue: _selectedModel,
                  decoration: const InputDecoration(
                    labelText: 'السيارة (اختياري)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_car),
                  ),
                  items: questionsState.carModels.map((m) {
                    return DropdownMenuItem(
                      value: m,
                      child: Text(m.displayName),
                    );
                  }).toList(),
                  onChanged: (m) => setState(() => _selectedModel = m),
                ),
                const SizedBox(height: 12),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان السؤال *',
                    hintText: 'مثال: ما هو أفضل نظام شحن؟',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'الرجاء إدخال عنوان السؤال';
                    }
                    if (v.trim().length < 10) return 'العنوان قصير جداً';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Body
                TextFormField(
                  controller: _bodyController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'تفاصيل السؤال *',
                    hintText: 'اشرح سؤالك بالتفصيل...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'الرجاء إدخال تفاصيل السؤال';
                    }
                    if (v.trim().length < 20) return 'التفاصيل قصيرة جداً';
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Error
                if (questionsState.submitError case final err?)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(err, style: TextStyle(color: cs.error)),
                  ),

                const SizedBox(height: 8),

                // Submit
                FilledButton(
                  onPressed:
                      authNotifier.isLoggedIn && !questionsState.isSubmitting
                      ? _submit
                      : null,
                  child: questionsState.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('نشر السؤال'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedModel == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء اختيار السيارة')));
      return;
    }

    final success = await context.read<CommunityCubit>().submitQuestion(
      carModelId: _selectedModel!.id,
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم نشر السؤال بنجاح')));
    }
  }
}
