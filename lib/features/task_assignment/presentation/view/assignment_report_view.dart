import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/file/attachment_section.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/task_assignment/data/model/work_report_detail_model.dart';
import 'package:toy_village_app/features/task_assignment/presentation/view_model/assignment_report_view_model.dart';

class AssignmentReportView extends ConsumerWidget {
  final int workReportId;

  const AssignmentReportView({super.key, required this.workReportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(assignmentReportViewModelProvider(workReportId)),
          onRetry: () =>
              ref.invalidate(assignmentReportViewModelProvider(workReportId)),
          data: (report) => _content(context, ref, report),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    WidgetRef ref,
    WorkReportDetailModel report,
  ) {
    final files = [
      for (final file in report.files)
        (fileName: file.fileName, fileKey: file.fileKey),
    ];
    final note = report.note;

    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 92),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              ToyVillageReadonlyField(
                label: '내용',
                value: report.content,
                minLines: 4,
              ),
              if (note != null && note.isNotEmpty) ...[
                const SizedBox(height: 40),
                ToyVillageReadonlyField(
                  label: '특이사항',
                  value: note,
                  minLines: 4,
                ),
              ],
              if (files.isNotEmpty) ...[
                const SizedBox(height: 40),
                AttachmentSection(files: files),
              ],
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 16,
          child: Row(
            children: [
              Expanded(
                child: ToyVillageButton(
                  label: '반려하기',
                  background: ToyVillageColor.gray10,
                  textColor: ToyVillageColor.red,
                  border: Border.all(color: ToyVillageColor.red),
                  onTap: () => _showRejectDialog(context, ref),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ToyVillageButton(
                  label: '승인하기',
                  onTap: () => _approve(context, ref),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    final error = await ref
        .read(reportReviewViewModelProvider.notifier)
        .approve(workReportId);
    if (!context.mounted) return;
    if (error != null) {
      showTopToast(Overlay.of(context), error, isError: true);
      return;
    }
    showTopToast(Overlay.of(context), '업무 보고를 승인했어요', isError: false);
    context.pop();
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: ToyVillageColor.gray10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                '반려 사유를 입력해주세요',
                style: ToyVillageTextStyle.heading6,
              ),
              const SizedBox(height: 16),
              Container(
                height: 140,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ToyVillageColor.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: ToyVillageTextStyle.body5,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '반려 사유 입력',
                    hintStyle: ToyVillageTextStyle.button5.copyWith(
                      color: ToyVillageColor.gray60,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(dialogContext).pop(),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ToyVillageColor.gray60,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '취소',
                          style: ToyVillageTextStyle.button4.copyWith(
                            color: ToyVillageColor.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _reject(
                        context,
                        dialogContext,
                        ref,
                        controller.text.trim(),
                      ),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ToyVillageColor.gray10,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ToyVillageColor.red),
                        ),
                        child: Text(
                          '반려',
                          style: ToyVillageTextStyle.button4.copyWith(
                            color: ToyVillageColor.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(controller.dispose);
  }

  Future<void> _reject(
    BuildContext context,
    BuildContext dialogContext,
    WidgetRef ref,
    String reason,
  ) async {
    if (reason.isEmpty) {
      showTopToast(Overlay.of(dialogContext), '반려 사유를 입력해주세요', isError: true);
      return;
    }
    final error = await ref
        .read(reportReviewViewModelProvider.notifier)
        .reject(workReportId, reason);
    if (dialogContext.mounted) Navigator.of(dialogContext).pop();
    if (!context.mounted) return;
    if (error != null) {
      showTopToast(Overlay.of(context), error, isError: true);
      return;
    }
    showTopToast(Overlay.of(context), '업무 보고를 반려했어요', isError: false);
    context.pop();
  }
}
