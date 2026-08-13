import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log.dart';
import 'package:toy_village_app/features/daily_log/presentation/view/daily_log_create_view.dart';
import 'package:toy_village_app/features/daily_log/presentation/view/daily_log_detail_view.dart';
import 'package:toy_village_app/features/daily_log/presentation/view/daily_log_view.dart';
import 'package:toy_village_app/features/day_off/presentation/view/day_off_view.dart';
import 'package:toy_village_app/features/document/presentation/view/document_view.dart';
import 'package:toy_village_app/features/notice/presentation/view/notice_detail_view.dart';
import 'package:toy_village_app/features/notice/presentation/view/notice_view.dart';
import 'package:toy_village_app/features/reservation/presentation/view/reservation_detail_view.dart';
import 'package:toy_village_app/features/reservation/presentation/view/reservation_view.dart';
import 'package:toy_village_app/features/task/presentation/view/task_detail_view.dart';
import 'package:toy_village_app/features/task/presentation/view/task_report_detail_view.dart';
import 'package:toy_village_app/features/task/presentation/view/task_report_view.dart';
import 'package:toy_village_app/features/task/presentation/view/task_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/reservation',
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
              return const Scaffold(body: Center(child: Text('잘못된 접근입니다.')));
            }
            return NoticeDetailView(id: id);
          },
        ),
      ],
    ),
    GoRoute(path: '/dayOff', builder: (context, state) => const DayOffView()),
    GoRoute(
      path: '/document',
      builder: (context, state) => const DocumentView(),
    ),
    GoRoute(
      path: '/reservation',
      builder: (context, state) => const ReservationView(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is! ({int id, String title})) {
              return const Scaffold(body: Center(child: Text('잘못된 접근입니다.')));
            }
            return ReservationDetailView(id: extra.id, title: extra.title);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/task',
      builder: (context, state) => const TaskView(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final id = state.extra;
            if (id is! int) {
              return const Scaffold(body: Center(child: Text('잘못된 접근입니다.')));
            }
            return TaskDetailView(id: id);
          },
        ),
        GoRoute(
          path: 'report',
          redirect: (context, state) =>
              state.fullPath == '/task/report' ? '/task' : null,
          builder: (context, state) => const SizedBox.shrink(),
          routes: [
            GoRoute(
              path: 'create',
              builder: (context, state) {
                final id = state.extra;
                if (id is! int) {
                  return const Scaffold(
                    body: Center(child: Text('잘못된 접근입니다.')),
                  );
                }
                return TaskReportView(id: id);
              },
            ),
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final id = state.extra;
                if (id is! int) {
                  return const Scaffold(
                    body: Center(child: Text('잘못된 접근입니다.')),
                  );
                }
                return TaskReportView(id: id);
              },
            ),
            GoRoute(
              path: 'detail',
              builder: (context, state) {
                final id = state.extra;
                if (id is! int) {
                  return const Scaffold(
                    body: Center(child: Text('잘못된 접근입니다.')),
                  );
                }
                return TaskReportDetailView(id: id);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/dailyLog',
      builder: (context, state) => const DailyLogView(),
      routes: [
        GoRoute(
          path: 'create',
          builder: (context, state) {
            final extra = state.extra;
            return DailyLogCreateView(
              log: extra is DailyLog ? extra : null,
            );
          },
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final id = state.extra;
            if (id is! int) {
              return const Scaffold(body: Center(child: Text('잘못된 접근입니다.')));
            }
            return DailyLogDetailView(id: id);
          },
        ),
      ],
    ),
  ],
);
