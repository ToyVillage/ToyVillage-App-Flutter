import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/empty_state.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/presentation/view_model/seen_task_view_model.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_report_view_model.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_view_model.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_card.dart';

int _rank(WidgetRef ref, TaskModel task) {
  final hasReport = ref.watch(taskReportProvider(task.id)).value != null;
  final status = hasReport && task.status == TaskStatus.notSubmitted
      ? TaskStatus.submitted
      : task.status;
  switch (status) {
    case TaskStatus.notSubmitted:
      final deadline = task.deadline;
      final expired = deadline != null && deadline.isBefore(DateTime.now());
      return expired ? 1 : 0;
    case TaskStatus.rejected:
      return 2;
    case TaskStatus.submitted:
      return 3;
    case TaskStatus.completed:
      return 4;
  }
}

class TaskView extends ConsumerWidget {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 22),
                child: ToyVillageTitle(
                  title: '오늘의 업무',
                  subTitle: '오늘 자신의 업무를 조회합니다',
                ),
              ),
              Expanded(
                child: CustomAsyncValue(
                  value: ref.watch(taskViewModelProvider),
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return const EmptyState(message: '오늘 등록된 업무가 없습니다');
                    }
                    final sorted = [...tasks]
                      ..sort((a, b) => _rank(ref, a).compareTo(_rank(ref, b)));
                    return ListView.builder(
                      itemCount: sorted.length,
                      itemBuilder: (context, index) =>
                          _TaskListItem(task: sorted[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskListItem extends ConsumerWidget {
  final TaskModel task;

  const _TaskListItem({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasReport = ref.watch(taskReportProvider(task.id)).value != null;
    final status = hasReport && task.status == TaskStatus.notSubmitted
        ? TaskStatus.submitted
        : task.status;
    final seenIds = ref.watch(seenTaskProvider).value ?? <int>{};

    return TaskCard(
      title: task.title,
      createdAt: task.createdAt,
      status: status,
      deadline: task.deadline,
      isNew: !seenIds.contains(task.id),
      onTap: () {
        ref.read(seenTaskProvider.notifier).markAsSeen(task.id);
        context.push('/task/detail', extra: task.id);
      },
    );
  }
}
