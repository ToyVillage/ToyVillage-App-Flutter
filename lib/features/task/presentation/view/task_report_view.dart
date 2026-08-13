import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';
import 'package:toy_village_app/features/task/data/repository/task_report_draft_repository.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_report_view_model.dart';
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
  bool _isEdit = false;

  TaskReportDraftRepository get _repo =>
      ref.read(taskReportDraftRepositoryProvider);

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
    final report = await _repo.loadReport(widget.id);
    final source = report ?? await _repo.load(widget.id);
    if (!mounted) return;
    if (source != null) {
      _contentController.text = source.content;
      _noteController.text = source.note;
      setState(() {
        _files = source.files;
        _isEdit = report != null;
      });
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
    _autoSaveTimer = Timer(const Duration(milliseconds: 1500), () async {
      try {
        await _repo.save(widget.id, _current());
      } catch (_) {}
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
      await _repo.save(widget.id, _current());
      showTopToast(overlay, '저장되었습니다.');
    } catch (_) {
      showTopToast(overlay, '저장을 실패했습니다. 다시 시도해주세요.', isError: true);
    }
  }

  Future<void> _complete() async {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (_contentController.text.trim().isEmpty) {
      showTopToast(overlay, '내용을 추가해야 합니다.', isError: true);
      return;
    }
    final container = ProviderScope.containerOf(context, listen: false);
    _autoSaveTimer?.cancel();
    await _repo.saveReport(widget.id, _current());
    await _repo.clear(widget.id);
    container.invalidate(taskReportProvider(widget.id));
    if (!mounted) return;
    context.go('/task');
  }

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(height: 20);

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
                Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: ToyVillageTitle(
                    title: _isEdit ? '업무 보고서 수정' : '업무 보고서 작성',
                  ),
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
                        spacing,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ToyVillageButton.outlined(
                          label: '임시저장',
                          onTap: _saveDraft,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ToyVillageButton(
                          label: '작성 완료하기',
                          onTap: _complete,
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
}
