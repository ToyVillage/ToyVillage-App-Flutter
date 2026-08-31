import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/checkbox_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/file_upload_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/radio_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/template_dropdown_field.dart';

class DailyLogContentView extends ConsumerStatefulWidget {
  final String templateName;

  const DailyLogContentView({super.key, required this.templateName});

  @override
  ConsumerState<DailyLogContentView> createState() =>
      _DailyLogContentViewState();
}

class _DailyLogContentViewState extends ConsumerState<DailyLogContentView> {
  static const _titleGap = 28.0;
  static const _sectionGap = 16.0;
  static const _labelGap = 12.0;
  static const _scrollBottomGap = 80.0;

  final List<String> _zones = const [
    'A1',
    'A2',
    'A3',
    'A4',
    'B1',
    'B2',
    'B3',
    'B4',
    'C1',
    'C2',
    'C3',
    'C4',
  ];

  int? _selectedZone;

  final List<String> _choices = const ['객관식 선지 1'];
  final bool _hasEtc = true;

  final _subjectiveController = TextEditingController();
  String? _dropdownValue;

  @override
  void dispose() {
    _subjectiveController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: const ToyVillageAppBar(hasIcon: true),
        body: SafeArea(
          child: Stack(
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
                      _section(
                        '구역 선택',
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _zones.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 1.7,
                              ),
                          itemBuilder: (context, index) {
                            final selected = _selectedZone == index;
                            return _ZoneCard(
                              label: _zones[index],
                              selected: selected,
                              onTap: () =>
                                  setState(() => _selectedZone = index),
                            );
                          },
                        ),
                      ),
                      _section(
                        '객관식',
                        RadioField(choices: _choices, hasEtc: _hasEtc),
                      ),
                      _section(
                        '체크박스',
                        CheckboxField(choices: _choices, hasEtc: _hasEtc),
                      ),
                      TemplateDropdownField(
                        label: '드롭다운',
                        hintText: '선택',
                        value: _dropdownValue,
                        items: dailyLogTemplates,
                        onChanged: (value) =>
                            setState(() => _dropdownValue = value),
                      ),
                      ToyVillageTextField(
                        label: '주관식',
                        hintText: '내용 입력',
                        controller: _subjectiveController,
                        scrollPadding: const EdgeInsets.only(bottom: 100),
                      ),
                      _section('파일 업로드', const FileUploadField()),
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
    );
  }
}

class _ZoneCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ZoneCard({
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
