import 'package:flutter/cupertino.dart';

class PullToRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final List<Widget> slivers;

  const PullToRefresh({
    super.key,
    required this.onRefresh,
    required this.slivers,
  });

  factory PullToRefresh.child({
    Key? key,
    required Future<void> Function() onRefresh,
    required Widget child,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return PullToRefresh(
      key: key,
      onRefresh: onRefresh,
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverToBoxAdapter(child: child),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: onRefresh),
        ...slivers,
      ],
    );
  }
}
