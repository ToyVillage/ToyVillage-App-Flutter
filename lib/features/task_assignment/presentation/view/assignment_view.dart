import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/task_assignment/data/model/assignment.dart';
import 'package:toy_village_app/features/task_assignment/presentation/widget/assignment_card.dart';

class AssignmentView extends StatelessWidget {
  const AssignmentView({super.key});

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
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 92),
                      itemCount: sampleAssignments.length,
                      itemBuilder: (context, index) {
                        final assignment = sampleAssignments[index];
                        return AssignmentCard(
                          assignment: assignment,
                          onTap: () => context.push(
                            '/task-assignment/detail',
                            extra: assignment.id,
                          ),
                          onDelete: () {},
                        );
                      },
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
