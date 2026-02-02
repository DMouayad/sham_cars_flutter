import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/community/community_repository.dart';
import 'package:sham_cars/features/questions/question_details_cubit.dart';

class QuestionDetailsScreen extends StatelessWidget {
  const QuestionDetailsScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          QuestionDetailsCubit(context.read<CommunityRepository>())..load(id),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Question')),
            body: BlocBuilder<QuestionDetailsCubit, QuestionDetailsState>(
              builder: (context, state) {
                if (state.isLoading && state.question == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(
                    child: Text('An error occurred: ${state.error}'),
                  );
                }

                final question = state.question;
                if (question == null) {
                  return const Center(child: Text('Question not found.'));
                }

                return Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        child: Text(question.userName[0]),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            question.userName,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                          Text(
                                            _formatDate(question.createdAt),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    question.body,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(),
                                  Text(
                                    '${question.answers.length} Answers',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final answer = question.answers[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child: Text(answer.userName[0]),
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                answer.userName,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                              ),
                                              Text(
                                                _formatDate(answer.createdAt),
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        answer.body,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }, childCount: question.answers.length),
                          ),
                        ],
                      ),
                    ),
                    const _AnswerInput(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) return 'الآن';
      return 'منذ ${diff.inHours} ساعة';
    }
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _AnswerInput extends StatefulWidget {
  const _AnswerInput();

  @override
  State<_AnswerInput> createState() => _AnswerInputState();
}

class _AnswerInputState extends State<_AnswerInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.isNotEmpty) {
      context.read<QuestionDetailsCubit>().submitAnswer(body: _controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionDetailsCubit, QuestionDetailsState>(
      listener: (context, state) {
        if (state.submitError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit answer: ${state.submitError}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Write your answer...',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<QuestionDetailsCubit, QuestionDetailsState>(
              builder: (context, state) {
                if (state.isSubmitting) {
                  return const CircularProgressIndicator();
                }
                return IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _submit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
