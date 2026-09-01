import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_detail.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_template.dart';
import 'package:toy_village_app/features/daily_log/data/model/question_type.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_detail_view_model.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_template_view_model.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/checkbox_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/file_upload_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/radio_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/template_dropdown_field.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';

class DailyLogEditView extends ConsumerStatefulWidget {
  final int workLogId;
  final int templateId;

  const DailyLogEditView({
    super.key,
    required this.workLogId,
    required this.templateId,
  });

  @override
  ConsumerState<DailyLogEditView> createState() => _DailyLogEditViewState();
}

class _DailyLogEditViewState extends ConsumerState<DailyLogEditView> {
  static const _sectionGap = 16.0;
  static const _labelGap = 12.0;
  static const _scrollBottomGap = 80.0;

  bool _initialized = false;

  int? _selectedSectionId;
  final Map<int, TextEditingController> _textControllers = {};
  final Map<int, String?> _radioValues = {};
  final Map<int, List<String>> _checkboxValues = {};
  final Map<int, String?> _dropdownValues = {};
  final Map<int, List<ReportAttachment>> _fileValues = {};

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _prefill(DailyLogDetail detail) {
    for (final section in detail.sections) {
      if (section.answers.isNotEmpty) {
        _selectedSectionId ??= section.sectionId;
      }
      for (final answer in section.answers) {
        switch (answer.questionType) {
          case QuestionType.shortText:
          case QuestionType.longText:
            _textControllers[answer.questionId] = TextEditingController(
              text: answer.answerText ?? '',
            );
          case QuestionType.multipleChoice:
          case QuestionType.dropDown:
            _radioValues[answer.questionId] = answer.answerText;
            _dropdownValues[answer.questionId] = answer.answerText;
          case QuestionType.checkBox:
            _checkboxValues[answer.questionId] = answer.answerText == null
                ? []
                : [answer.answerText!];
          case QuestionType.fileUpload:
            _fileValues[answer.questionId] = answer.file == null
                ? []
                : [answer.file!];
        }
      }
    }
    _initialized = true;
  }

  TextEditingController _controllerFor(int questionId) {
    return _textControllers.putIfAbsent(questionId, TextEditingController.new);
  }

  void _save() {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (_selectedSectionId == null) {
      showTopToast(overlay, '구역을 선택해주세요.', isError: true);
      return;
    }
    context.pop();
  }

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
            RadioField(
              choices: choices,
              hasEtc: hasEtc,
              initialValue: _radioValues[question.questionId],
              onChanged: (value) => _radioValues[question.questionId] = value,
            ),
          ],
        );
      case QuestionType.checkBox:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label,
            const SizedBox(height: _labelGap),
            CheckboxField(
              choices: choices,
              hasEtc: hasEtc,
              initialValues: _checkboxValues[question.questionId] ?? const [],
              onChanged: (value) =>
                  _checkboxValues[question.questionId] = value,
            ),
          ],
        );
      case QuestionType.dropDown:
        return TemplateDropdownField(
          label: question.question,
          hintText: '선택',
          items: choices,
          value: _dropdownValues[question.questionId],
          onChanged: (value) =>
              setState(() => _dropdownValues[question.questionId] = value),
        );
      case QuestionType.fileUpload:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label,
            const SizedBox(height: _labelGap),
            FileUploadField(
              initialFiles: _fileValues[question.questionId] ?? const [],
              onChanged: (value) => _fileValues[question.questionId] = value,
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final template = ref.watch(
      dailyLogTemplateViewModelProvider(widget.templateId),
    );
    final detail = ref.watch(dailyLogDetailViewModelProvider(widget.workLogId));

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: const ToyVillageAppBar(hasIcon: true),
        body: SafeArea(
          child: CustomAsyncValue(
            value: detail,
            data: (detail) {
              if (!_initialized) _prefill(detail);
              return CustomAsyncValue(
                value: template,
                data: (template) => _form(template),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _form(DailyLogTemplate template) {
    return Stack(
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
                  padding: EdgeInsets.only(bottom: 12),
                  child: ToyVillageTitle(title: '업무일지 수정'),
                ),
                _section('구역 선택', _sectionGrid(template.sections)),
                for (final question in template.questions) _question(question),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 16,
          child: ToyVillageButton(label: '수정 완료하기', onTap: _save),
        ),
      ],
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
