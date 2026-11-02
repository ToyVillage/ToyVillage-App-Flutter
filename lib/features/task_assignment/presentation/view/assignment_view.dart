import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/dialog/delete_confirm_dialog.dart';
import 'package:toy_village_app/core/widgets/empty_state.dart';
import 'package:toy_village_app/core/widgets/pull_to_refresh.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task_assignment/presentation/view_model/assignment_list_view_model.dart';
import 'package:toy_village_app/features/task_assignment/presentation/view_model/assignment_mutation_view_model.dart';
import 'package:toy_village_app/features/task_assignment/presentation/widget/assignment_card.dart';

class AssignmentView extends ConsumerWidget {
  const AssignmentView({super.key});

  Future<void> _onRefresh(WidgetRef ref) async {
    ref.invalidate(assignmentListViewModelProvider);
    await ref.read(assignmentListViewModelProvider.future);
  }

  Future<void> _onDelete(
    BuildContext context,
    WidgetRef ref,
    TaskModel assignment,
  ) async {
    final confirmed = await showDeleteConfirmDialog(context);
    if (!confirmed || !context.mounted) return;

    final error = await ref
        .read(assignmentMutationViewModelProvider.notifier)
        .delete(assignment.id);
    if (!context.mounted) return;

    if (error != null) {
      showTopToast(Overlay.of(context), error, isError: true);
      return;
    }
    ref.invalidate(assignmentListViewModelProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: ToyVillageTitle(
                      title: '업무 관리',
                      subTitle: '업무를 생성하고 직원들에게 할당합니다',
                    ),
                  ),
                  Expanded(
                    child: CustomAsyncValue(
                      value: ref.watch(assignmentListViewModelProvider),
                      onRetry: () =>
                          ref.invalidate(assignmentListViewModelProvider),
                      data: (assignments) => _list(context, ref, assignments),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 16,
              child: ToyVillageButton(
                label: '업무 생성',
                onTap: () async {
                  await context.push('/task-assignment/create');
                  ref.invalidate(assignmentListViewModelProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(
    BuildContext context,
    WidgetRef ref,
    List<TaskModel> assignments,
  ) {
    if (assignments.isEmpty) {
      return PullToRefresh.child(
        onRefresh: () => _onRefresh(ref),
        child: const SizedBox(
          height: 400,
          child: EmptyState(message: '아직 생성한 업무가 없어요'),
        ),
      );
    }

    return PullToRefresh(
      onRefresh: () => _onRefresh(ref),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 92),
          sliver: SliverList.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              return AssignmentCard(
                assignment: assignment,
                onTap: () => context.push(
                  '/task-assignment/detail',
                  extra: assignment.id,
                ),
                onDelete: () => _onDelete(context, ref, assignment),
                onUpdate: () async {
                  await context.push(
                    '/task-assignment/create',
                    extra: assignment.id,
                  );
                  ref.invalidate(assignmentListViewModelProvider);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
