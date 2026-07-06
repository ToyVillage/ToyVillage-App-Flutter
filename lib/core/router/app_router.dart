import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/features/notice/presentation/view/notice_detail_view.dart';
import 'package:toy_village_app/features/notice/presentation/view/notice_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/notice',
  routes: [
    GoRoute(
      path: '/notice',
      builder: (context, state) => const NoticeView(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            return NoticeDetailView(id: state.extra as int);
          },
        ),
      ],
    ),
  ],
);
