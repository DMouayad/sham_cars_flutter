import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/custom_scaffold.dart';

import 'cubits/my_answered_questions_cubit.dart';
import 'cubits/my_questions_cubit.dart';
import 'cubits/my_reviews_cubit.dart';
import 'repositories/user_activity_repository.dart';
import 'widgets/tabs.dart';

class MyActivityScreen extends StatelessWidget {
  const MyActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<UserActivityRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MyReviewsCubit(repo)),
        BlocProvider(create: (_) => MyQuestionsCubit(repo)),
        BlocProvider(create: (_) => MyAnsweredQuestionsCubit(repo)),
      ],
      child: CustomScaffold(body: const _MyActivityView()),
    );
  }
}

class _MyActivityView extends StatefulWidget {
  const _MyActivityView();

  @override
  State<_MyActivityView> createState() => _MyActivityViewState();
}

class _MyActivityViewState extends State<_MyActivityView> {
  @override
  void initState() {
    super.initState();

    context.read<MyQuestionsCubit>().refresh();
    context.read<MyReviewsCubit>().refresh();
    context.read<MyAnsweredQuestionsCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Material(
            color: cs.surface,
            child: TabBar(
              tabs: [
                Tab(text: l10n.profileMyReviewsTab),
                Tab(text: l10n.profileMyQuestionsTab),
                Tab(text: l10n.profileMyAnsweredQuestionsTab),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: const [
                MyReviewsTab(),
                MyQuestionsTab(),
                MyAnsweredQuestionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
