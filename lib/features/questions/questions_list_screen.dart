import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/community/community_cubit.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/theme/constants.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.onOpenQuestion});

  final void Function(int id) onOpenQuestion;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأسئلة والأجوبة'), centerTitle: true),
      body: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          if (state.isLoading && state.questions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.questions.isEmpty) {
            return _ErrorView(
              error: state.error!,
              onRetry: () => context.read<CommunityCubit>().load(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<CommunityCubit>().load(),
            child: CustomScrollView(
              slivers: [
                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(ThemeConstants.p),
                    child: _SearchBar(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      onChanged: (q) =>
                          context.read<CommunityCubit>().search(q),
                      onClear: () {
                        _searchController.clear();
                        // context.read<CommunityCubit>().clearSearch();
                      },
                    ),
                  ),
                ),

                // Stats
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.p,
                    ),
                    child: _StatsRow(
                      total: state.questions.length,
                      filtered: state.filteredQuestions.length,
                      isFiltered: state.searchQuery.isNotEmpty,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Questions List
                if (state.filteredQuestions.isEmpty)
                  SliverFillRemaining(
                    child: _EmptyView(
                      isSearching: state.searchQuery.isNotEmpty,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.p,
                    ),
                    sliver: SliverList.separated(
                      itemCount: state.filteredQuestions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final question = state.filteredQuestions[i];
                        return QuestionCard(
                          question: question,
                          onTap: () => widget.onOpenQuestion(question.id),
                        );
                      },
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to ask question
          _showAskQuestionSheet(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('اطرح سؤالاً'),
      ),
    );
  }

  void _showAskQuestionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _AskQuestionSheet(),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'ابحث في الأسئلة...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.close), onPressed: onClear)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.rCard),
        ),
        filled: true,
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.total,
    required this.filtered,
    required this.isFiltered,
  });

  final int total;
  final int filtered;
  final bool isFiltered;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = isFiltered ? '$filtered من $total سؤال' : '$total سؤال';

    return Row(
      children: [
        Icon(Icons.question_answer_outlined, size: 18, color: cs.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.isSearching});

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.forum_outlined,
            size: 64,
            color: cs.outline,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'لا توجد نتائج' : 'لا توجد أسئلة بعد',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            isSearching ? 'جرب كلمات بحث مختلفة' : 'كن أول من يطرح سؤالاً!',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.outline),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('حدث خطأ', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
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

class _AskQuestionSheet extends StatefulWidget {
  const _AskQuestionSheet();

  @override
  State<_AskQuestionSheet> createState() => _AskQuestionSheetState();
}

class _AskQuestionSheetState extends State<_AskQuestionSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ThemeConstants.p,
        right: ThemeConstants.p,
        top: ThemeConstants.p,
        bottom: MediaQuery.of(context).viewInsets.bottom + ThemeConstants.p,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'اطرح سؤالاً',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'عنوان السؤال',
              hintText: 'مثال: ما هو أفضل نظام شحن؟',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'تفاصيل السؤال',
              hintText: 'اشرح سؤالك بالتفصيل...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              // TODO: Submit question (needs auth)
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('يجب تسجيل الدخول لطرح سؤال')),
              );
            },
            child: const Text('نشر السؤال'),
          ),
        ],
      ),
    );
  }
}
