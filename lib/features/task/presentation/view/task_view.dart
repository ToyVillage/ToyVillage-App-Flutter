import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_list_skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/empty_state.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/presentation/view_model/seen_task_view_model.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_view_model.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_card.dart';

int _rank(TaskModel task, DateTime now) {
  if (task.status == TaskStatus.completed) return 2;
  final finishDate = task.finishDate;
  final expired = finishDate != null && finishDate.isBefore(now);
  return expired ? 0 : 1;
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
                  loading: const TaskListSkeleton(),
                  onRetry: () => ref.invalidate(taskViewModelProvider),
                  data: (tasks) {
                    final now = DateTime.now();
                    final sorted = [...tasks]
                      ..sort((a, b) => _rank(a, now).compareTo(_rank(b, now)));
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () =>
                              ref.refresh(taskViewModelProvider.future),
                        ),
                        if (sorted.isEmpty)
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: EmptyState(message: '오늘 등록된 업무가 없습니다'),
                          )
                        else
                          SliverList.builder(
                            itemCount: sorted.length,
                            itemBuilder: (context, index) =>
                                _TaskListItem(task: sorted[index]),
                          ),
                      ],
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
    final seenIds = ref.watch(seenTaskProvider).value ?? <int>{};

    return TaskCard(
      title: task.title,
      status: task.status,
      finishDate: task.finishDate,
      isNew: !seenIds.contains(task.id),
      onTap: () {
        ref.read(seenTaskProvider.notifier).markAsSeen(task.id);
        context.push('/task/detail', extra: task.id);
      },
    );
  }
}
