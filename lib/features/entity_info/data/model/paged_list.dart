class PagedList<T> {
  final List<T> items;
  final int nextPage;
  final bool hasMore;
  final bool isLoadingMore;

  const PagedList({
    required this.items,
    required this.nextPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  PagedList<T> copyWith({
    List<T>? items,
    int? nextPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PagedList(
      items: items ?? this.items,
      nextPage: nextPage ?? this.nextPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
