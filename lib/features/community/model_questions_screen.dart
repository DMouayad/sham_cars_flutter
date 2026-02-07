import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/question_card_skeleton.dart';

import 'cubits/model_questions_cubit.dart';

class ModelQuestionsScreen extends StatefulWidget {
  const ModelQuestionsScreen({
    super.key,
    required this.modelId,
    required this.title,
  });

  final int modelId;
  final String title;

  @override
  State<ModelQuestionsScreen> createState() => _ModelQuestionsScreenState();
}

class _ModelQuestionsScreenState extends State<ModelQuestionsScreen> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);

    // load
    Future.microtask(() {
      context.read<ModelQuestionsCubit>().load(modelId: widget.modelId);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final c = context.read<ModelQuestionsCubit>();
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 250) {
      c.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocBuilder<ModelQuestionsCubit, ModelQuestionsState>(
        builder: (context, state) {
          if (state.loadingInitial && state.questions.isEmpty) {
            return ListView.separated(
              itemBuilder: (context, index) => const QuestionCardSkeleton(),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 4,
              padding: const EdgeInsets.all(ThemeConstants.p),
            );
          }

          if (state.questions.isEmpty) {
            return Center(child: Text(context.l10n.modelQuestionsEmpty));
          }

          final count = state.questions.length + (state.hasMore ? 1 : 0);

          return RefreshIndicator(
            onRefresh: () => context.read<ModelQuestionsCubit>().refresh(),
            child: ListView.separated(
              controller: _controller,
              padding: const EdgeInsets.all(ThemeConstants.p),
              itemCount: count,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                if (i == state.questions.length) {
                  return _BottomLoader(loading: state.loadingMore);
                }
                final q = state.questions[i];
                return QuestionCard(
                  question: q,
                  showContext: true,
                  onTap: () => QuestionDetailsRoute(q.id).push(context),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader({required this.loading});
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (!loading) return const SizedBox(height: 10);

    return const QuestionCardSkeleton();
  }
}
