import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/reviews/widgets/review_card.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/widgets/compact_trim_card.dart';
import 'package:sham_cars/features/vehicle/widgets/trim_card.dart';
import 'package:sham_cars/utils/utils.dart';

import 'home_cubit.dart';
import 'models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onOpenTrim,
    required this.onOpenQuestion,
    required this.onViewAllVehicles,
    required this.onViewAllQuestions,
  });

  final void Function(int trimId, [CarTrimSummary? summary]) onOpenTrim;
  final void Function(int questionId) onOpenQuestion;
  final VoidCallback onViewAllVehicles;
  final VoidCallback onViewAllQuestions;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final _debouncer = Debouncer(milliseconds: 400);

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading && !state.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && !state.hasData) {
            return _ErrorView(
              error: state.error!,
              onRetry: () => context.read<HomeCubit>().load(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().refresh(),
            child: CustomScrollView(
              slivers: [
                // Search
                PinnedHeaderSliver(
                  child: Container(
                    color: context.colorScheme.surface,
                    padding: const EdgeInsets.all(ThemeConstants.p),
                    child: _SearchField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      isSearching: state.isSearching,
                      onChanged: (q) {
                        _debouncer.run(() {
                          context.read<HomeCubit>().search(q);
                        });
                      },
                      onClear: () {
                        _searchController.clear();
                        context.read<HomeCubit>().clearSearch();
                      },
                    ),
                  ),
                ),

                // Show search results OR regular content
                if (state.showSearchResults)
                  ..._buildSearchResults(state)
                else if (state.data != null)
                  ..._buildHomeContent(state.data!),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildSearchResults(HomeState state) {
    if (state.isSearching) {
      return [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ];
    }

    if (state.searchResults.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: _EmptySearchResults(query: state.searchQuery),
        ),
      ];
    }

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
          child: Text(
            '${state.searchResults.length} نتيجة',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
        sliver: SliverList.separated(
          itemCount: state.searchResults.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final trim = state.searchResults[i];
            return TrimCard(
              trim: trim,
              onTap: () => widget.onOpenTrim(trim.id, trim),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _buildHomeContent(HomeData data) {
    return [
      // Featured Vehicles
      if (data.featuredTrims.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: _SectionHeader(
            title: 'سيارات مميزة',
            onTap: widget.onViewAllVehicles,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
              itemCount: data.featuredTrims.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final trim = data.featuredTrims[i];
                return CompactTrimCard(
                  trim: trim,
                  onTap: () => widget.onOpenTrim(trim.id, trim),
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],

      // Latest Questions
      if (data.latestQuestions.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: _SectionHeader(
            title: 'أحدث الأسئلة',
            onTap: widget.onViewAllQuestions,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
          sliver: SliverList.separated(
            itemCount: data.latestQuestions.take(3).length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final q = data.latestQuestions[i];
              return QuestionCard(
                question: q,
                compact: true,
                onTap: () => widget.onOpenQuestion(q.id),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],

      // Latest Reviews
      if (data.latestReviews.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: _SectionHeader(
            title: 'أحدث التجارب',
            onTap: widget.onViewAllVehicles,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
          sliver: SliverList.separated(
            itemCount: data.latestReviews.take(3).length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final r = data.latestReviews[i];
              return ReviewCard(review: r, onTap: () {});
            },
          ),
        ),
      ],
    ];
  }
}

// Search field with loading indicator
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.isSearching,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSearching;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'ابحث عن سيارة...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: isSearching
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : controller.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.close), onPressed: onClear)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.rCard),
        ),
        filled: true,
        fillColor: cs.surfaceContainerHighest,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ThemeConstants.p,
        0,
        ThemeConstants.p,
        12,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          TextButton(onPressed: onTap, child: const Text('عرض الكل')),
        ],
      ),
    );
  }
}

class _EmptySearchResults extends StatelessWidget {
  const _EmptySearchResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: cs.outline),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج لـ "$query"',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'جرب كلمات بحث مختلفة',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
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
    );
  }
}

// Simple debouncer
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
