import 'package:flutter/material.dart';
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
            final id = state.extra;
            if (id is! int) {
              return const Scaffold(
                body: Center(child: Text('잘못된 접근입니다.')),
              );
            }
            return NoticeDetailView(id: id);
          },
        ),
      ],
    ),
  ],
);
