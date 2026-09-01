import 'package:flutter/material.dart';
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
import 'package:toy_village_app/features/daily_log/data/model/question_type.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_detail_view_model.dart';

class DailyLogDetailView extends ConsumerWidget {
  final int id;

  const DailyLogDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(dailyLogDetailViewModelProvider(id));

    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: detail,
          data: (detail) => Padding(
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
                        Expanded(
                          child: ToyVillageTitle(title: detail.templateTitle),
                        ),
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
                              onTap: () => _delete(context),
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
                    _answer(context, answer),
                ],
              ),
            ),
          ),
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

  Widget _answer(BuildContext context, Answer answer) {
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

    return ToyVillageReadonlyField(
      label: answer.question,
      value: answer.answerText ?? '',
      minLines: answer.questionType == QuestionType.longText ? 5 : 1,
    );
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDeleteConfirmDialog(context);
    if (!confirmed) return;
    if (!context.mounted) return;
    context.go('/daily-log');
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
