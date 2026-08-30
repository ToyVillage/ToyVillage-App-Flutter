import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/bottom_bar/main_scaffold.dart';
import 'package:toy_village_app/features/auth/presentation/view/login_view.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log.dart';
import 'package:toy_village_app/features/daily_log/presentation/view/daily_log_content_view.dart';
import 'package:toy_village_app/features/daily_log/presentation/view/daily_log_create_view.dart';
import 'package:toy_village_app/features/daily_log/presentation/view/daily_log_detail_view.dart';
import 'package:toy_village_app/features/daily_log/presentation/view/daily_log_view.dart';
import 'package:toy_village_app/features/day_off/presentation/view/day_off_view.dart';
import 'package:toy_village_app/features/document/presentation/view/document_view.dart';
import 'package:toy_village_app/features/entity_info/presentation/view/entity_info_detail_view.dart';
import 'package:toy_village_app/features/entity_info/presentation/view/entity_info_view.dart';
import 'package:toy_village_app/features/menu/presentation/view/menu_view.dart';
import 'package:toy_village_app/features/notice/presentation/view/notice_detail_view.dart';
import 'package:toy_village_app/features/notice/presentation/view/notice_view.dart';
import 'package:toy_village_app/features/password/presentation/view/password_view.dart';
import 'package:toy_village_app/features/reservation/presentation/view/reservation_detail_view.dart';
import 'package:toy_village_app/features/reservation/presentation/view/reservation_view.dart';
import 'package:toy_village_app/features/task/presentation/view/task_detail_view.dart';
import 'package:toy_village_app/features/task/presentation/view/task_report_detail_view.dart';
import 'package:toy_village_app/features/task/presentation/view/task_report_view.dart';
import 'package:toy_village_app/features/task/presentation/view/task_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

const _invalidAccess = Scaffold(
  appBar: ToyVillageAppBar(hasIcon: true),
  body: Center(child: Text('잘못된 접근입니다.')),
);

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notice',
              builder: (context, state) => const NoticeView(),
              routes: [
                GoRoute(
                  path: 'detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.extra;
                    if (id is! int) return _invalidAccess;
                    return NoticeDetailView(id: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/day-off',
              builder: (context, state) => const DayOffView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/task',
              builder: (context, state) => const TaskView(),
              routes: [
                GoRoute(
                  path: 'detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.extra;
                    if (id is! int) return _invalidAccess;
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
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final id = state.extra;
                        if (id is! int) return _invalidAccess;
                        return TaskReportView(id: id);
                      },
                    ),
                    GoRoute(
                      path: 'edit',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final id = state.extra;
                        if (id is! int) return _invalidAccess;
                        return TaskReportView(id: id);
                      },
                    ),
                    GoRoute(
                      path: 'detail',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final id = state.extra;
                        if (id is! int) return _invalidAccess;
                        return TaskReportDetailView(id: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/document',
              builder: (context, state) => const DocumentView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/menu',
              builder: (context, state) => const MenuView(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/reservation',
      builder: (context, state) => const ReservationView(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is! ({int id, String title})) return _invalidAccess;
            return ReservationDetailView(id: extra.id, title: extra.title);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/daily-log',
      builder: (context, state) => const DailyLogView(),
      routes: [
        GoRoute(
          path: 'create',
          builder: (context, state) {
            final extra = state.extra;
            return DailyLogCreateView(log: extra is DailyLog ? extra : null);
          },
          routes: [
            GoRoute(
              path: 'content',
              builder: (context, state) {
                final template = state.extra;
                if (template is! String) return _invalidAccess;
                return DailyLogContentView(templateName: template);
              },
            ),
          ],
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final id = state.extra;
            if (id is! int) return _invalidAccess;
            return DailyLogDetailView(id: id);
          },
        ),
      ],
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    GoRoute(
      path: '/password',
      builder: (context, state) => const PasswordView(),
    ),
    GoRoute(
      path: '/entity-info',
      builder: (context, state) => const EntityInfoView(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final id = state.extra;
            if (id is! int) return _invalidAccess;
            return EntityInfoDetailView(id: id);
          },
        ),
      ]
    ),
  ],
);
