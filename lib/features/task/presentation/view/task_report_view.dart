import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_loading_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';
import 'package:toy_village_app/features/task/data/model/work_report_request.dart';
import 'package:toy_village_app/features/task/data/repository/task_report_draft_repository.dart';
import 'package:toy_village_app/features/task/data/repository/work_report_repository.dart';
import 'package:toy_village_app/features/task/presentation/view_model/work_report_view_model.dart';
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
  bool _loading = true;
  bool _loadFailed = false;
  bool _isSubmitting = false;
  bool _isEdit = false;
  int? _workReportId;
  bool _uploading = false;
  bool _dirty = false;
  bool _autoSaveShown = false;
  String _originalContent = '';
  String _originalNote = '';
  List<String> _originalFileKeys = const [];

  TaskReportDraftRepository get _draftRepo =>
      ref.read(taskReportDraftRepositoryProvider);

  WorkReportRepository get _repo => ref.read(workReportRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_onEdited);
    _noteController.addListener(_onEdited);
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
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      final report = await _repo.loadMyReport(widget.id);
      if (!mounted) return;
      if (report != null) {
        _contentController.text = report.content;
        _noteController.text = report.note ?? '';
        _files = report.files
            .map(
              (f) => ReportAttachment(fileName: f.fileName, fileKey: f.fileKey),
            )
            .toList();
        _isEdit = true;
        _workReportId = report.id;
        _originalContent = report.content;
        _originalNote = report.note ?? '';
        _originalFileKeys = report.files.map((f) => f.fileKey).toList();
      } else {
        final draft = await _draftRepo.load(widget.id);
        if (!mounted) return;
        if (draft != null) {
          _contentController.text = draft.content;
          _noteController.text = draft.note;
          _files = draft.files;
        }
      }
      if (!mounted) return;
      setState(() {
        _loaded = true;
        _loading = false;
        _dirty = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadFailed = true;
      });
    }
  }

  TaskReportDraft _currentDraft() => TaskReportDraft(
    content: _contentController.text,
    note: _noteController.text,
    files: _files,
  );

  WorkReportRequest _request() {
    final note = _noteController.text.trim();
    return WorkReportRequest(
      content: _contentController.text.trim(),
      note: note.isEmpty ? null : note,
      fileKey: _files.map((f) => f.fileKey).toList(),
    );
  }

  void _onEdited() {
    setState(() => _dirty = true);
    _scheduleAutoSave();
  }

  Color get _autoSaveColor =>
      _dirty ? ToyVillageColor.gray60 : ToyVillageColor.gray100;

  bool get _canSubmit {
    if (_contentController.text.trim().isEmpty) return false;
    if (!_isEdit) return true;
    final filesChanged = !listEquals(
      _files.map((f) => f.fileKey).toList(),
      _originalFileKeys,
    );
    return _contentController.text != _originalContent ||
        _noteController.text != _originalNote ||
        filesChanged;
  }

  void _scheduleAutoSave() {
    if (!_loaded || _isEdit) return;
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 30), () async {
      try {
        await _draftRepo.save(widget.id, _currentDraft());
        if (!mounted) return;
        setState(() {
          _autoSaveShown = true;
          _dirty = false;
        });
      } catch (_) {}
    });
  }

  Future<void> _addAttachment() async {
    setState(() => _uploading = true);
    final attachment = await pickAndUploadAttachment(context, ref);
    if (!mounted) return;
    setState(() {
      _uploading = false;
      if (attachment != null) _files = [..._files, attachment];
    });
    if (attachment != null) _scheduleAutoSave();
  }

  void _deleteAttachment(int index) {
    setState(() => _files = [..._files]..removeAt(index));
    _scheduleAutoSave();
  }

  Future<void> _saveDraft() async {
    final overlay = Overlay.of(context, rootOverlay: true);
    try {
      await _draftRepo.save(widget.id, _currentDraft());
      showTopToast(overlay, '저장되었습니다.');
    } catch (_) {
      showTopToast(overlay, '저장을 실패했습니다. 다시 시도해주세요.', isError: true);
    }
  }

  Future<void> _complete() async {
    if (_isSubmitting) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    if (_contentController.text.trim().isEmpty) {
      showTopToast(overlay, '내용을 추가해야 합니다.', isError: true);
      return;
    }
    _autoSaveTimer?.cancel();
    setState(() => _isSubmitting = true);
    try {
      final workReportId = _workReportId;
      if (_isEdit && workReportId != null) {
        await _repo.updateReport(workReportId, _request());
      } else {
        await _repo.createReport(widget.id, _request());
      }
      await _draftRepo.clear(widget.id);
      ref.invalidate(workReportProvider(widget.id));
      if (!mounted) return;
      context.go('/task');
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      showTopToast(overlay, '업무 보고 등록에 실패했습니다. 다시 시도해주세요.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(height: 20);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ToyVillageAppBar(hasIcon: true),
        body: SafeArea(child: _body(spacing)),
      ),
    );
  }

  Widget _body(Widget spacing) {
    if (_loading) {
      return const Center(child: AppLoadingIndicator());
    }
    if (_loadFailed) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('보고서를 불러오지 못했어요.'),
            const SizedBox(height: 12),
            ToyVillageButton.outlined(label: '다시 시도', onTap: _load),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: Row(
                  children: [
                    Expanded(
                      child: ToyVillageTitle(
                        title: _isEdit ? '업무 보고서 수정' : '업무 보고서 작성',
                      ),
                    ),
                    if (_autoSaveShown) ...[
                      Icon(
                        Symbols.check,
                        size: 24,
                        color: _autoSaveColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '자동 저장됨',
                        style: ToyVillageTextStyle.caption4.copyWith(
                          color: _autoSaveColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80),
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
                        uploading: _uploading,
                      ),
                      spacing,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 16,
          child: Row(
            children: [
              if (!_isEdit) ...[
                Expanded(
                  child: ToyVillageButton.outlined(
                    label: '임시저장',
                    onTap: _saveDraft,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: ToyVillageButton(
                  label: _isSubmitting ? '등록 중' : '작성 완료하기',
                  background: (_canSubmit && !_isSubmitting)
                      ? ToyVillageColor.gray100
                      : ToyVillageColor.gray60,
                  onTap: (_canSubmit && !_isSubmitting) ? _complete : () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
