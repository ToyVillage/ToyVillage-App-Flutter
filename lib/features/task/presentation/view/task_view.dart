import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_list_skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/dropdown/menu_dropdown.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/empty_state.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/task/data/model/task_filter.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/presentation/view_model/seen_task_view_model.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_view_model.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_card.dart';

int _rank(TaskModel task) {
  switch (task.status) {
    case TaskStatus.expired:
      return 0;
    case TaskStatus.inProgress:
      return 1;
    case TaskStatus.completed:
      return 2;
  }
}

class TaskView extends ConsumerStatefulWidget {
  const TaskView({super.key});

  @override
  ConsumerState<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends ConsumerState<TaskView> {
  TaskFilter _filter = TaskFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: ToyVillageTitle(
                        title: '오늘의 업무',
                        subTitle: '오늘 자신의 업무를 조회합니다',
                      ),
                    ),
                    MenuDropdown(
                      items: [
                        for (final filter in TaskFilter.values)
                          MenuDropdownItem(
                            label: filter.label,
                            color: filter == _filter
                                ? ToyVillageColor.gray100
                                : ToyVillageColor.gray60,
                            onTap: () => setState(() => _filter = filter),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomAsyncValue(
                  value: ref.watch(taskViewModelProvider),
                  loading: const TaskListSkeleton(),
                  onRetry: () => ref.invalidate(taskViewModelProvider),
                  data: (tasks) {
                    final sorted = [
                      for (final task in tasks)
                        if (_filter.matches(task)) task,
                    ]..sort((a, b) => _rank(a).compareTo(_rank(b)));
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
      reportStatus: task.myReportStatus,
      finishDate: task.finishDate,
      isNew: !seenIds.contains(task.id),
      onTap: () {
        ref.read(seenTaskProvider.notifier).markAsSeen(task.id);
        context.push('/task/detail', extra: task.id);
      },
    );
  }
}
