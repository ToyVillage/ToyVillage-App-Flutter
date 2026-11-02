import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/dialog/delete_confirm_dialog.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/task_assignment/data/model/assignment.dart';
import 'package:toy_village_app/features/task_assignment/presentation/widget/assignment_card.dart';

class AssignmentView extends StatefulWidget {
  const AssignmentView({super.key});

  @override
  State<AssignmentView> createState() => _AssignmentViewState();
}

class _AssignmentViewState extends State<AssignmentView> {
  final List<Assignment> _assignments = List.of(sampleAssignments);

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _onDelete(BuildContext context, Assignment assignment) async {
    if (assignment.hasReport) {
      showTopToast(
        Overlay.of(context),
        '업무보고가 등록된 업무는 삭제할 수 없습니다',
        isError: true,
      );
      return;
    }
    final confirmed = await showDeleteConfirmDialog(context);
    if (confirmed) {
      setState(() => _assignments.remove(assignment));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        CupertinoSliverRefreshControl(onRefresh: _onRefresh),
                        SliverPadding(
                          padding: const EdgeInsets.only(bottom: 92),
                          sliver: SliverList.builder(
                            itemCount: _assignments.length,
                            itemBuilder: (context, index) {
                              final assignment = _assignments[index];
                              return AssignmentCard(
                                assignment: assignment,
                                onTap: () => context.push(
                                  '/task-assignment/detail',
                                  extra: assignment.id,
                                ),
                                onDelete: () => _onDelete(context, assignment),
                                onUpdate: () => context.push(
                                  '/task-assignment/create',
                                  extra: assignment,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
                onTap: () => context.push('/task-assignment/create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
