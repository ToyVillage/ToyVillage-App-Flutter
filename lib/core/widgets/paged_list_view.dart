import 'package:flutter/cupertino.dart';
import 'package:toy_village_app/core/widgets/app_loading_indicator.dart';

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

  Widget _loader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: AppLoadingIndicator(radius: 10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = items.length + (hasMore && isLoadingMore ? 1 : 0);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (hasMore &&
            !isLoadingMore &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          if (onRefresh != null)
            CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverPadding(
            padding: padding,
            sliver: SliverList.separated(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index >= items.length) return _loader();
                return itemBuilder(context, items[index]);
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: separatorHeight),
            ),
          ),
        ],
      ),
    );
  }
}
