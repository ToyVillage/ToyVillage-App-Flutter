import 'package:flutter/cupertino.dart';

/// 업무지시 조회와 동일한 iOS 스타일 당겨서 새로고침 래퍼.
class PullToRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final List<Widget> slivers;

  const PullToRefresh({
    super.key,
    required this.onRefresh,
    required this.slivers,
  });

  /// 단일 콘텐츠(상세 화면 등)를 감쌀 때 사용.
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
