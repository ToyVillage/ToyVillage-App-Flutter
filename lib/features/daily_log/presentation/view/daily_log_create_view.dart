import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log.dart';
import 'package:toy_village_app/features/daily_log/data/repository/daily_log_draft_repository.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_view_model.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/template_dropdown_field.dart';

class DailyLogCreateView extends ConsumerStatefulWidget {
  final DailyLog? log;

  const DailyLogCreateView({super.key, this.log});

  @override
  ConsumerState<DailyLogCreateView> createState() => _DailyLogCreateViewState();
}

class _DailyLogCreateViewState extends ConsumerState<DailyLogCreateView> {
  final _contentController = TextEditingController();
  String? _template;

  bool get _isEdit => widget.log != null;

  DailyLogDraftRepository get _repo =>
      ref.read(dailyLogDraftRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.log?.id;
    final draft = await _repo.load(id);
    if (!mounted) return;
    if (draft != null && !draft.isEmpty) {
      setState(() => _template = draft.templateName);
      _contentController.text = draft.content;
      return;
    }
    final log = widget.log;
    if (log != null) {
      setState(() => _template = log.templateName);
      _contentController.text = log.content;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  String get _title {
    final log = widget.log;
    if (log != null) {
      return '${log.createdAt.month}월 ${log.createdAt.day}일 업무일지';
    }
    return '업무일지 작성';
  }

  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/dailyLog');
    }
  }

  bool _validate() {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (_template == null) {
      showTopToast(overlay, '양식을 선택해주세요.', isError: true);
      return false;
    }
    if (_contentController.text.trim().isEmpty) {
      showTopToast(overlay, '내용을 추가해야 합니다.', isError: true);
      return false;
    }
    return true;
  }

  Future<void> _saveDraft() async {
    final overlay = Overlay.of(context, rootOverlay: true);
    try {
      await _repo.save(
        widget.log?.id,
        DailyLogDraft(
          templateName: _template,
          content: _contentController.text,
        ),
      );
      showTopToast(overlay, '임시저장 됐어요.');
    } catch (_) {
      showTopToast(overlay, '임시저장에 실패했어요. 다시 시도해주세요.', isError: true);
    }
  }

  Future<void> _complete() async {
    if (!_validate()) return;
    ref
        .read(dailyLogViewModelProvider.notifier)
        .add(templateName: _template!, content: _contentController.text.trim());
    await _repo.clear(widget.log?.id);
    if (!mounted) return;
    _leave();
  }

  Future<void> _saveEdit() async {
    if (!_validate()) return;
    ref
        .read(dailyLogViewModelProvider.notifier)
        .update(
          widget.log!.id,
          templateName: _template!,
          content: _contentController.text.trim(),
        );
    await _repo.clear(widget.log!.id);
    if (!mounted) return;
    _leave();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ToyVillageAppBar(closeIcon: true),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: ToyVillageTitle(title: _title),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TemplateDropdownField(
                              label: '양식 선택',
                              hintText: '업무일지 양식을 선택해주세요',
                              value: _template,
                              items: dailyLogTemplates,
                              onChanged: (value) =>
                                  setState(() => _template = value),
                            ),
                            const SizedBox(height: 20),
                            ToyVillageTextField(
                              label: '내용',
                              minLines: 14,
                              hintText: '내용 입력',
                              controller: _contentController,
                            ),
                            const SizedBox(height: 20),
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
                child: _isEdit
                    ? ToyVillageButton(
                        label: '수정사항 저장하기',
                        onTap: _saveEdit,
                      )
                    : Row(
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
    );
  }
}
