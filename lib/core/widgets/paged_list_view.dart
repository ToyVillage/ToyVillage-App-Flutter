import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';

class PagedListView<T> extends StatelessWidget {
  final List<T> items;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final Widget Function(BuildContext, T) itemBuilder;
  final EdgeInsetsGeometry padding;
  final double separatorHeight;
  final Future<void> Function()? onRefresh;

  const PagedListView({
    super.key,
    required this.items,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.itemBuilder,
    this.padding = EdgeInsets.zero,
    this.separatorHeight = 8,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final list = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (hasMore &&
            !isLoadingMore &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        padding: padding,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length + (hasMore && isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ToyVillageColor.gray60,
                  ),
                ),
              ),
            );
          }
          return itemBuilder(context, items[index]);
        },
        separatorBuilder: (context, index) => SizedBox(height: separatorHeight),
      ),
    );

    if (onRefresh == null) return list;
    return RefreshIndicator(
      onRefresh: onRefresh!,
      color: ToyVillageColor.gray100,
      child: list,
    );
  }
}
