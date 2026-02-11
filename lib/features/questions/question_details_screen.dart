import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/home/widgets/custom_drawer.dart';

import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/router/routes.dart';

import 'models.dart';
import 'question_details_cubit.dart';

class QuestionDetailsScreen extends StatelessWidget {
  const QuestionDetailsScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionDetailsCubit(context.read())..load(id),
      child: const _QuestionDetailsView(),
    );
  }
}

class _QuestionDetailsView extends StatefulWidget {
  const _QuestionDetailsView();

  @override
  State<_QuestionDetailsView> createState() => _QuestionDetailsViewState();
}

class _QuestionDetailsViewState extends State<_QuestionDetailsView> {
  final _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      endDrawer: const CustomDrawer(),

      body: BlocConsumer<QuestionDetailsCubit, QuestionDetailsState>(
        listenWhen: (p, c) =>
            p.submitError != c.submitError && c.submitError != null,
        listener: (context, state) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.submitError!)));
        },
        builder: (context, state) {
          if (state.isLoading && state.question == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.question == null) {
            return _ErrorView(
              message: state.error.toString(),
              onRetry: () => context.read<QuestionDetailsCubit>().refresh(),
            );
          }

          final q = state.question!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: cs.surface.withOpacity(0.90),
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                leading: const BackButton(),
                title: Text(
                  q.title,
                  // style: TextTheme.of(context).titleLarge?.copyWith(
                  //   fontWeight: FontWeight.w700,
                  //   color: cs.primary,
                  //   height: 1.2,
                  // ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(ThemeConstants.p),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _RelatedVehicleCard(question: q),
                    const SizedBox(height: 12),
                    _QuestionCard(question: q),

                    const SizedBox(height: 16),
                    _SectionTitle(title: 'الإجابات (${q.answers.length})'),
                    const SizedBox(height: 10),

                    if (q.answers.isEmpty)
                      _EmptyBox(text: 'لا توجد إجابات بعد. كن أول من يجيب.')
                    else
                      ...q.answers.map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _AnswerCard(answer: a),
                        ),
                      ),

                    const SizedBox(height: 90), // space for composer
                  ]),
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar:
          BlocBuilder<QuestionDetailsCubit, QuestionDetailsState>(
            builder: (context, state) {
              if (state.question == null) return const SizedBox.shrink();

              return SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    border: Border(top: BorderSide(color: cs.outlineVariant)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _answerController,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'اكتب إجابة...',
                            isDense: true,
                            filled: true,
                            fillColor: cs.surfaceContainerHighest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () async {
                                final text = _answerController.text.trim();
                                if (text.isEmpty) return;

                                final ok = await context
                                    .read<QuestionDetailsCubit>()
                                    .submitAnswer(body: text);
                                if (ok) _answerController.clear();
                              },
                        icon: state.isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}

class _RelatedVehicleCard extends StatelessWidget {
  const _RelatedVehicleCard({required this.question});
  final Question question;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final trimId = question.trimId; // from new API doc
    final modelName = (question.modelName ?? '').trim();
    final trimName = (question.trimName ?? '').trim();

    final title = [
      if (modelName.isNotEmpty) modelName,
      if (trimName.isNotEmpty) trimName,
    ].join(' • ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: ThemeConstants.cardRadius,
      ),
      child: Row(
        children: [
          Icon(Icons.directions_car_outlined, color: cs.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title.isEmpty ? 'مرتبطة بسيارة' : title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: trimId == null
                ? null
                : () => VehicleDetailsRoute(id: trimId).push(context),
            child: const Text('عرض السيارة'),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.question});
  final Question question;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: cs.primaryContainer,
        borderRadius: ThemeConstants.cardRadius,
        border: Border.all(color: cs.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Body (readable block)
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              question.body,
              style: tt.bodyLarge?.copyWith(color: cs.onSurface, height: 1.7),
            ),
          ),

          // Author row
          Row(
            children: [
              _AvatarLetter(name: question.userName, isAuthor: true),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                _formatDate(question.createdAt),
                style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({required this.answer});
  final Answer answer;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: ThemeConstants.cardRadius,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            answer.body,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.65,
            ),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              _AvatarLetter(name: answer.userName, isAuthor: false),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  answer.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                _formatDate(answer.createdAt),
                style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
  );
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: ThemeConstants.cardRadius,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(text, style: TextStyle(color: cs.onSurfaceVariant)),
    );
  }
}

class _AvatarLetter extends StatelessWidget {
  const _AvatarLetter({required this.name, required this.isAuthor});
  final String name;
  final bool isAuthor;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final letter = name.trim().isNotEmpty
        ? name.trim().characters.first.toUpperCase()
        : '?';

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: isAuthor ? cs.primaryContainer : cs.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
        // border: Border.all(color: cs.outlineVariant),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: isAuthor ? cs.onPrimaryContainer : cs.onSecondaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: cs.error),
            const SizedBox(height: 12),
            Text('حدث خطأ', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime dt) {
  final y = dt.year.toString();
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y/$m/$d';
}
