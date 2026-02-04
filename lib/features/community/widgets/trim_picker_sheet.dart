import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/community/cubits/trim_picker_cubit.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class TrimPickerSheet extends StatefulWidget {
  const TrimPickerSheet({super.key});

  @override
  State<TrimPickerSheet> createState() => _TrimPickerSheetState();
}

class _TrimPickerSheetState extends State<TrimPickerSheet> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TrimPickerCubit>().loadInitial();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 250) {
      context.read<TrimPickerCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, sheetScroll) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(ThemeConstants.rCard),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.p,
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'ابحث عن نسخة سيارة...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (q) => context.read<TrimPickerCubit>().search(q),
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: BlocBuilder<TrimPickerCubit, TrimPickerState>(
                  builder: (context, state) {
                    if (state.loadingInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.error != null && state.items.isEmpty) {
                      return Center(child: Text('حدث خطأ: ${state.error}'));
                    }
                    if (state.items.isEmpty) {
                      return const Center(child: Text('لا توجد نتائج'));
                    }

                    final count = state.items.length + (state.hasMore ? 1 : 0);

                    return ListView.separated(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(
                        ThemeConstants.p,
                        0,
                        ThemeConstants.p,
                        24,
                      ),
                      itemCount: count,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        if (i == state.items.length) {
                          return Center(
                            child: state.loadingMore
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          );
                        }

                        final t = state.items[i];
                        return _TrimTile(
                          trim: t,
                          onTap: () =>
                              Navigator.pop<CarTrimSummary>(context, t),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TrimTile extends StatelessWidget {
  const _TrimTile({required this.trim, required this.onTap});

  final CarTrimSummary trim;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surface,
      borderRadius: ThemeConstants.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: ThemeConstants.cardRadius,
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: cs.outlineVariant),
            borderRadius: ThemeConstants.cardRadius,
          ),
          child: Row(
            children: [
              const Icon(Icons.directions_car_outlined),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  trim.fullName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
