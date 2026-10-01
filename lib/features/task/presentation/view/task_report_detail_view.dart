import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/pull_to_refresh.dart';
import 'package:toy_village_app/features/task/presentation/widget/work_report_detail_skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/empty_state.dart';
import 'package:toy_village_app/core/widgets/file/attachment_section.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/data/model/work_report_model.dart';
import 'package:toy_village_app/features/task/presentation/view_model/work_report_view_model.dart';

class TaskReportDetailView extends ConsumerWidget {
  final int id;

  const TaskReportDetailView({super.key, required this.id});

  Future<void> _resubmit(BuildContext context, WidgetRef ref) async {
    await context.push('/task/report/edit', extra: id);
    if (!context.mounted) return;
    ref.invalidate(workReportProvider(id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(workReportProvider(id)),
          loading: const WorkReportDetailSkeleton(),
          onRetry: () => ref.invalidate(workReportProvider(id)),
          data: (report) => _content(context, ref, report),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    WidgetRef ref,
    WorkReportModel? report,
  ) {
    final canResubmit = report != null && report.status == ReportStatus.rejected;

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 28),
                child: ToyVillageTitle(title: '업무 보고서'),
              ),
              Expanded(
                child: PullToRefresh.child(
                  onRefresh: () async {
                    ref.invalidate(workReportProvider(id));
                    await ref.read(workReportProvider(id).future);
                  },
                  padding: EdgeInsets.only(bottom: canResubmit ? 80 : 0),
                  child: report == null
                      ? const Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: EmptyState(message: '제출된 보고서가 없습니다'),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ToyVillageReadonlyField(
                              label: '내용',
                              value: report.content,
                              minLines: 7,
                            ),
                            if ((report.note ?? '').isNotEmpty) ...[
                              const SizedBox(height: 20),
                              ToyVillageReadonlyField(
                                label: '특이사항',
                                value: report.note!,
                                minLines: 4,
                              ),
                            ],
                            if (report.files.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              AttachmentSection(
                                files: report.files
                                    .map(
                                      (f) => (
                                        fileName: f.fileName,
                                        fileKey: f.fileKey,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                            const SizedBox(height: 20),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
        if (canResubmit)
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: ToyVillageButton(
              label: '수정하고 다시 제출하기',
              onTap: () => _resubmit(context, ref),
            ),
          ),
      ],
    );
  }
}
