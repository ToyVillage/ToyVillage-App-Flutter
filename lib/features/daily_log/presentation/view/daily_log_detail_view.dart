import 'package:flutter/material.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/daily_log_detail_skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/file_download.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/dialog/delete_confirm_dialog.dart';
import 'package:toy_village_app/core/widgets/dropdown/menu_dropdown.dart';
import 'package:toy_village_app/core/widgets/file/file_attachment.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_detail.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_template.dart';
import 'package:toy_village_app/features/daily_log/data/model/question_type.dart';
import 'package:toy_village_app/features/daily_log/data/repository/daily_log_detail_repository.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_detail_view_model.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_template_view_model.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/my_daily_log_view_model.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/checkbox_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/radio_field.dart';

class DailyLogDetailView extends ConsumerWidget {
  final int id;

  const DailyLogDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(dailyLogDetailViewModelProvider(id)),
          loading: const DailyLogDetailSkeleton(),
          onRetry: () => ref.invalidate(dailyLogDetailViewModelProvider(id)),
          data: (detail) => CustomAsyncValue(
            value: ref.watch(
              dailyLogTemplateViewModelProvider(detail.templateId),
            ),
            loading: const DailyLogDetailSkeleton(),
            onRetry: () => ref.invalidate(
              dailyLogTemplateViewModelProvider(detail.templateId),
            ),
            data: (template) => _content(context, ref, detail, template),
          ),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    WidgetRef ref,
    DailyLogDetail detail,
    DailyLogTemplate template,
  ) {
    final questionsById = {
      for (final question in template.questions) question.questionId: question,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(child: ToyVillageTitle(title: detail.templateTitle)),
                  MenuDropdown(
                    items: [
                      MenuDropdownItem(
                        label: '수정',
                        onTap: () => context.push(
                          '/daily-log/edit',
                          extra: (
                            workLogId: detail.workLogId,
                            templateId: detail.templateId,
                          ),
                        ),
                      ),
                      MenuDropdownItem(
                        label: '삭제',
                        color: ToyVillageColor.red,
                        onTap: () => _delete(context, ref),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _section('구역 선택', _sectionGrid(detail.sections)),
            ToyVillageReadonlyField(
              label: '양식 선택',
              value: detail.templateTitle,
            ),
            for (final answer in _answers(detail.sections))
              _answer(context, answer, questionsById[answer.questionId]),
          ],
        ),
      ),
    );
  }

  List<Answer> _answers(List<AnswerSection> sections) {
    return [for (final section in sections) ...section.answers];
  }

  Widget _section(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToyVillageLabel(label: label),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _sectionGrid(List<AnswerSection> sections) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sections.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (context, index) {
        final section = sections[index];
        return _SectionCard(
          label: section.sectionName,
          selected: section.answers.isNotEmpty,
        );
      },
    );
  }

  int _optionIndex(TemplateQuestion question, int optionId) {
    final normal = [
      for (final option in question.options)
        if (!option.etcOption) option,
    ];
    for (var i = 0; i < normal.length; i++) {
      if (normal[i].optionId == optionId) return i;
    }
    return normal.length;
  }

  Widget _labeled(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToyVillageLabel(label: label),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _answer(
    BuildContext context,
    Answer answer,
    TemplateQuestion? question,
  ) {
    if (answer.questionType == QuestionType.fileUpload) {
      final file = answer.file;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToyVillageLabel(label: answer.question),
          const SizedBox(height: 8),
          if (file != null)
            GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisExtent: 60,
              children: [
                FileAttachment(
                  fileName: file.fileName,
                  onDownload: () => downloadFile(
                    context,
                    fileName: file.fileName,
                    fileKey: file.fileKey,
                  ),
                ),
              ],
            ),
        ],
      );
    }

    if (question != null &&
        answer.questionType == QuestionType.multipleChoice) {
      final choices = [
        for (final option in question.options)
          if (!option.etcOption) option.content,
      ];
      final hasEtc = question.options.any((option) => option.etcOption);
      final selected = answer.options.isEmpty ? null : answer.options.first;
      return _labeled(
        answer.question,
        RadioField(
          choices: choices,
          hasEtc: hasEtc,
          readOnly: true,
          initialIndex: selected == null
              ? null
              : _optionIndex(question, selected.optionId),
          initialEtcText: selected?.etcText,
        ),
      );
    }

    if (question != null && answer.questionType == QuestionType.checkBox) {
      final choices = [
        for (final option in question.options)
          if (!option.etcOption) option.content,
      ];
      final hasEtc = question.options.any((option) => option.etcOption);
      final indices = {
        for (final option in answer.options)
          _optionIndex(question, option.optionId),
      };
      String? etcText;
      for (final option in answer.options) {
        if (option.etcOption) etcText = option.etcText;
      }
      return _labeled(
        answer.question,
        CheckboxField(
          choices: choices,
          hasEtc: hasEtc,
          readOnly: true,
          initialIndices: indices,
          initialEtcText: etcText,
        ),
      );
    }

    return ToyVillageReadonlyField(
      label: answer.question,
      value: answer.answerText ?? '',
      minLines: 5,
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final overlay = Overlay.of(context, rootOverlay: true);
    final confirmed = await showDeleteConfirmDialog(context);
    if (!confirmed) return;
    try {
      await ref.read(dailyLogDetailRepositoryProvider).deleteWorkLog(id);
      ref.invalidate(myDailyLogViewModelProvider);
      if (!context.mounted) return;
      context.go('/daily-log');
    } catch (e, stackTrace) {
      debugPrint('[DailyLog Delete Error] id=$id: $e');
      debugPrint('$stackTrace');
      showTopToast(overlay, '삭제에 실패했어요. 다시 시도해주세요.', isError: true);
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String label;
  final bool selected;

  const _SectionCard({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? ToyVillageColor.gray100 : ToyVillageColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: ToyVillageTextStyle.button4.copyWith(
          color: selected ? ToyVillageColor.white : ToyVillageColor.gray100,
        ),
      ),
    );
  }
}
