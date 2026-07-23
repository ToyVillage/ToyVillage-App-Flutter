import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar.dart';
import 'package:toy_village_app/features/notice/presentation/widget/file_attachment.dart';
import 'package:toy_village_app/features/task/presentation/widget/add_attachment_button.dart';
import 'package:toy_village_app/features/task/presentation/widget/file_upload_box.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_bottom_button.dart';

class TaskReportView extends ConsumerStatefulWidget {
  final int? taskId;

  const TaskReportView({super.key, this.taskId});

  @override
  ConsumerState<TaskReportView> createState() => _TaskReportViewState();
}

class _TaskReportViewState extends ConsumerState<TaskReportView> {
  final _contentController = TextEditingController();

  // TODO: 서버 연동 시 업로드된 첨부파일 목록으로 교체
  final List<String> _attachments = [];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _pickFile() {
    // TODO: file_picker 연동 후 첨부파일 추가
  }

  void _submit() {
    // TODO: 서버 연동 시 보고서 제출 로직 연결
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _contentController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: ToyVillageAppBar(closeIcon: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('업무 보고서 작성', style: ToyVillageTextStyle.heading1),
                      const SizedBox(height: 28),
                      Text('내용', style: ToyVillageTextStyle.subTitle4),
                      const SizedBox(height: 12),
                      _ContentField(
                        controller: _contentController,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 28),
                      Text('첨부파일', style: ToyVillageTextStyle.subTitle4),
                      const SizedBox(height: 16),
                      _AttachmentSection(
                        attachments: _attachments,
                        onAdd: _pickFile,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: TaskBottomButton(
                  label: '작성 완료하기',
                  onPressed: canSubmit ? _submit : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _ContentField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: 8,
        minLines: 8,
        cursorColor: ToyVillageColor.gray100,
        style: ToyVillageTextStyle.body5,
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: '내용 입력',
          hintStyle: ToyVillageTextStyle.body5.copyWith(
            color: ToyVillageColor.gray50,
          ),
        ),
      ),
    );
  }
}

class _AttachmentSection extends StatelessWidget {
  final List<String> attachments;
  final VoidCallback onAdd;

  const _AttachmentSection({required this.attachments, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return FileUploadBox(onTap: onAdd);
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attachments.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 60,
      ),
      itemBuilder: (context, index) {
        if (index == attachments.length) {
          return AddAttachmentButton(onTap: onAdd);
        }
        return FileAttachment(
          fileName: attachments[index],
          onDownload: () {},
        );
      },
    );
  }
}
