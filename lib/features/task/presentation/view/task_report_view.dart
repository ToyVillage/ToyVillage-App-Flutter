import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';
import 'package:toy_village_app/features/task/data/repository/task_report_draft_repository.dart';
import 'package:toy_village_app/features/task/presentation/widget/attachment_editor.dart';
import 'package:toy_village_app/features/task/presentation/widget/attachment_picker.dart';

class TaskReportView extends ConsumerStatefulWidget {
  final int id;

  const TaskReportView({super.key, required this.id});

  @override
  ConsumerState<TaskReportView> createState() => _TaskReportViewState();
}

class _TaskReportViewState extends ConsumerState<TaskReportView> {
  final _contentController = TextEditingController();
  final _noteController = TextEditingController();
  List<ReportAttachment> _files = [];
  Timer? _autoSaveTimer;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_scheduleAutoSave);
    _noteController.addListener(_scheduleAutoSave);
    _load();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _contentController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final draft = await ref
        .read(taskReportDraftRepositoryProvider)
        .load(widget.id);
    if (!mounted) return;
    if (draft != null) {
      _contentController.text = draft.content;
      _noteController.text = draft.note;
      setState(() => _files = draft.files);

      final overlay = Overlay.of(context, rootOverlay: true);
      await ref
          .read(taskReportDraftRepositoryProvider)
          .save(widget.id, _current());
      showTopToast(overlay, '저장된 데이터를 불러왔습니다.');
    }
    _loaded = true;
  }

  TaskReportDraft _current() => TaskReportDraft(
    content: _contentController.text,
    note: _noteController.text,
    files: _files,
  );

  void _scheduleAutoSave() {
    if (!_loaded) return;
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(milliseconds: 1500), () {
      ref.read(taskReportDraftRepositoryProvider).save(widget.id, _current());
    });
  }

  Future<void> _addAttachment() async {
    final attachment = await pickAndUploadAttachment(context, ref);
    if (attachment == null || !mounted) return;
    setState(() => _files = [..._files, attachment]);
    _scheduleAutoSave();
  }

  void _deleteAttachment(int index) {
    setState(() => _files = [..._files]..removeAt(index));
    _scheduleAutoSave();
  }

  Future<void> _saveDraft() async {
    final overlay = Overlay.of(context, rootOverlay: true);
    try {
      await ref
          .read(taskReportDraftRepositoryProvider)
          .save(widget.id, _current());
      showTopToast(overlay, '저장되었습니다.');
    } catch (_) {
      showTopToast(overlay, '저장을 실패했습니다. 다시 시도해주세요.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(height: 20);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ToyVillageAppBar(closeIcon: true),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 28),
                  child: ToyVillageTitle(title: '업무 보고서 작성'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ToyVillageTextField(
                          label: '내용',
                          hintText: '내용 입력',
                          minLines: 7,
                          controller: _contentController,
                        ),
                        spacing,
                        ToyVillageTextField(
                          label: '특이사항',
                          hintText: '내용 입력',
                          minLines: 4,
                          isOptional: true,
                          controller: _noteController,
                        ),
                        spacing,
                        const ToyVillageLabel(label: '첨부파일', isOptional: true),
                        const SizedBox(height: 8),
                        AttachmentEditor(
                          files: _files,
                          onAdd: _addAttachment,
                          onDelete: _deleteAttachment,
                        ),
                        spacing
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: _button(
                          label: '임시저장',
                          background: ToyVillageColor.gray10,
                          textColor: ToyVillageColor.gray100,
                          border: Border.all(color: ToyVillageColor.gray100),
                          onTap: _saveDraft,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 5,
                        child: _button(
                          label: '작성 완료하기',
                          background: ToyVillageColor.gray100,
                          textColor: ToyVillageColor.white,
                          onTap: () {
                            context.go('/task');
                            _contentController.clear();
                            _noteController.clear();
                            // TODO: 파일도 삭제되도록
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _button({
    required String label,
    required Color background,
    required Color textColor,
    required VoidCallback onTap,
    Border? border,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: border,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.5),
          child: Center(
            child: Text(
              label,
              style: ToyVillageTextStyle.button3.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
