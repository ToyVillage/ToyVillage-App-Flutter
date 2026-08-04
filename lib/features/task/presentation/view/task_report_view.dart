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
  final LayerLink _menuLink = LayerLink();
  List<ReportAttachment> _files = [];
  Timer? _autoSaveTimer;
  OverlayEntry? _menuEntry;
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
    _menuEntry?.remove();
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

  void _toggleMenu() => _menuEntry != null ? _closeMenu() : _openMenu();

  void _openMenu() {
    _menuEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeMenu,
            ),
          ),
          CompositedTransformFollower(
            link: _menuLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: const Offset(0, 8),
            child: Container(
              width: 80,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: ToyVillageColor.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    offset: Offset.zero,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          _closeMenu();
                          _handleDelete();
                        },
                        child: Center(
                          child: Text(
                            '삭제',
                            style: ToyVillageTextStyle.caption3.copyWith(
                              color: ToyVillageColor.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_menuEntry!);
  }

  void _closeMenu() {
    _menuEntry?.remove();
    _menuEntry = null;
  }

  Future<void> _handleDelete() async {
    final container = ProviderScope.containerOf(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: ToyVillageColor.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 31),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                const TextSpan(
                  children: [
                    TextSpan(text: '정말 '),
                    TextSpan(
                      text: '삭제',
                      style: TextStyle(color: ToyVillageColor.red),
                    ),
                    TextSpan(text: '하시겠습니까?'),
                  ],
                ),
                style: ToyVillageTextStyle.heading6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '삭제한 후에는\n다시 복구할 수 없습니다.',
                style: ToyVillageTextStyle.body5.copyWith(
                  color: ToyVillageColor.gray60,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogButton(
                    label: '취소',
                    background: ToyVillageColor.gray60,
                    textColor: ToyVillageColor.white,
                    onTap: () => Navigator.pop(ctx, false),
                  ),
                  const SizedBox(width: 11),
                  _dialogButton(
                    label: '삭제',
                    background: ToyVillageColor.white,
                    textColor: ToyVillageColor.red,
                    border: Border.all(color: ToyVillageColor.red),
                    onTap: () => Navigator.pop(ctx, true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true) return;
    await _repo.clearReport(widget.id);
    await _repo.clear(widget.id);
    container.invalidate(taskReportProvider(widget.id));
    if (!mounted) return;
    context.go('/task');
  }

  Widget _dialogButton({
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
          padding: const EdgeInsets.symmetric(horizontal: 59, vertical: 12.5),
          child: Text(
            label,
            style: ToyVillageTextStyle.button3.copyWith(color: textColor),
          ),
        ),
      ),
    );
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
                  child: Row(
                    children: [
                      ToyVillageTitle(
                        title: _isEdit ? '업무 보고서 수정' : '업무 보고서 작성',
                      ),
                      if (_isEdit) ...[
                        const Spacer(),
                        CompositedTransformTarget(
                          link: _menuLink,
                          child: IconButton(
                            onPressed: _toggleMenu,
                            padding: EdgeInsets.zero,
                            style: IconButton.styleFrom(
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(
                              Icons.more_vert,
                              color: ToyVillageColor.gray100,
                            ),
                          ),
                        ),
                      ],
                    ],
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
