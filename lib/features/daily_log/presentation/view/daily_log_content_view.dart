import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_template.dart';
import 'package:toy_village_app/features/daily_log/data/model/question_type.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_template_view_model.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/checkbox_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/file_upload_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/radio_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/template_dropdown_field.dart';

class DailyLogContentView extends ConsumerStatefulWidget {
  final int templateId;

  const DailyLogContentView({super.key, required this.templateId});

  @override
  ConsumerState<DailyLogContentView> createState() =>
      _DailyLogContentViewState();
}

class _DailyLogContentViewState extends ConsumerState<DailyLogContentView> {
  static const _titleGap = 28.0;
  static const _sectionGap = 16.0;
  static const _labelGap = 12.0;
  static const _scrollBottomGap = 80.0;

  int? _selectedSectionId;
  final Map<int, TextEditingController> _textControllers = {};
  final Map<int, String?> _dropdownValues = {};

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(int questionId) {
    return _textControllers.putIfAbsent(questionId, TextEditingController.new);
  }

  void _saveDraft() {}

  void _complete() {}

  Widget _section(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToyVillageLabel(label: label),
        const SizedBox(height: _labelGap),
        child,
      ],
    );
  }

  Widget _sectionGrid(List<TemplateSection> sections) {
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
          selected: _selectedSectionId == section.sectionId,
          onTap: () => setState(() => _selectedSectionId = section.sectionId),
        );
      },
    );
  }

  Widget _question(TemplateQuestion question) {
    final label = ToyVillageLabel(label: question.question);
    final choices = question.options
        .where((option) => !option.etcOption)
        .map((option) => option.content)
        .toList();
    final hasEtc = question.options.any((option) => option.etcOption);

    switch (question.questionType) {
      case QuestionType.shortText:
        return ToyVillageTextField(
          label: question.question,
          hintText: '내용 입력',
          controller: _controllerFor(question.questionId),
          scrollPadding: const EdgeInsets.only(bottom: 100),
        );
      case QuestionType.longText:
        return ToyVillageTextField(
          label: question.question,
          hintText: '내용 입력',
          minLines: 5,
          controller: _controllerFor(question.questionId),
          scrollPadding: const EdgeInsets.only(bottom: 100),
        );
      case QuestionType.multipleChoice:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label,
            const SizedBox(height: _labelGap),
            RadioField(choices: choices, hasEtc: hasEtc),
          ],
        );
      case QuestionType.checkBox:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label,
            const SizedBox(height: _labelGap),
            CheckboxField(choices: choices, hasEtc: hasEtc),
          ],
        );
      case QuestionType.dropDown:
        return TemplateDropdownField(
          label: question.question,
          hintText: '선택',
          value: _dropdownValues[question.questionId],
          items: choices,
          onChanged: (value) =>
              setState(() => _dropdownValues[question.questionId] = value),
        );
      case QuestionType.fileUpload:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label,
            const SizedBox(height: _labelGap),
            const FileUploadField(),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final template = ref.watch(
      dailyLogTemplateViewModelProvider(widget.templateId),
    );

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: const ToyVillageAppBar(hasIcon: true),
        body: SafeArea(
          child: CustomAsyncValue(
            value: template,
            data: (template) => Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: _scrollBottomGap),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: _sectionGap,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            bottom: _titleGap - _sectionGap,
                          ),
                          child: ToyVillageTitle(title: '업무일지 작성'),
                        ),
                        _section('구역 선택', _sectionGrid(template.sections)),
                        for (final question in template.questions)
                          _question(question),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 16,
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

class _SectionCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SectionCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
