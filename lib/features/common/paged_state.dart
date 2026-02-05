class PagedState<T> {
  final bool loadingInitial;
  final bool loadingMore;
  final bool hasMore;
  final int skip;
  final List<T> items;
  final Object? error;

  const PagedState({
    this.loadingInitial = false,
    this.loadingMore = false,
    this.hasMore = true,
    this.skip = 0,
    this.items = const [],
    this.error,
  });

  PagedState<T> copyWith({
    bool? loadingInitial,
    bool? loadingMore,
    bool? hasMore,
    int? skip,
    List<T>? items,
    Object? error,
    bool clearError = false,
  }) {
    return PagedState<T>(
      loadingInitial: loadingInitial ?? this.loadingInitial,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
      items: items ?? this.items,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
