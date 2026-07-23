import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/title.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_view_model.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_bottom_button.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_card.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_list_skeleton.dart';

class TaskView extends ConsumerWidget {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ToyVillageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: CustomAsyncValue(
                  value: ref.watch(taskViewModelProvider),
                  loading: const TaskListSkeleton(),
                  data: (tasks) => CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: ToyVillageTitle(
                            title: '오늘의 업무',
                            subTitle: '오늘 자신의 업무를 조회합니다',
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final task = tasks[index];
                            return TaskCard(
                              title: task.title,
                              time: task.createdAt,
                              isCompleted: task.isCompleted,
                              showDot: !task.isReported,
                              onTap: () => context.push(
                                '/task/report',
                                extra: task.id,
                              ),
                            );
                          },
                          childCount: tasks.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: TaskBottomButton(
                  label: '업무 보고서 작성',
                  onPressed: () => context.push('/task/report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
