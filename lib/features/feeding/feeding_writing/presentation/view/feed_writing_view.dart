import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/template_dropdown_field.dart';
import 'package:toy_village_app/features/feeding/feeding_writing/presentation/widget/feed_amount_field.dart';
import 'package:toy_village_app/features/feeding/feeding_writing/presentation/widget/feed_date_field.dart';
import 'package:toy_village_app/features/feeding/feeding_writing/presentation/widget/feed_time_field.dart';

class FeedWritingView extends StatefulWidget {
  final String speciesName;
  final String category;

  const FeedWritingView({
    super.key,
    required this.speciesName,
    required this.category,
  });

  @override
  State<FeedWritingView> createState() => _FeedWritingViewState();
}

class _FeedWritingViewState extends State<FeedWritingView> {
  static const _sectionGap = 16.0;
  static const _labelGap = 12.0;
  static const _scrollBottomGap = 80.0;

  DateTime? _date;
  FeedTime? _startTime;
  FeedTime? _endTime;
  String? _target;
  String _amountUnit = feedAmountUnits.first;

  final _feedTypeController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  List<String> get _targets => [
    '${widget.speciesName}1',
    '${widget.speciesName}2',
    '${widget.speciesName}3',
  ];

  @override
  void dispose() {
    _feedTypeController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

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
                        padding: EdgeInsets.only(bottom: 12),
                        child: ToyVillageTitle(title: '먹이 급여 작성'),
                      ),
                      _section(
                        '급여 날짜',
                        FeedDateField(
                          value: _date,
                          onChanged: (value) => setState(() => _date = value),
                        ),
                      ),
                      _section(
                        '급여 시간',
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FeedTimeField(
                                hintText: '시작 시각 선택',
                                value: _startTime,
                                onChanged: (value) =>
                                    setState(() => _startTime = value),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FeedTimeField(
                                hintText: '종료 시각 선택',
                                value: _endTime,
                                onChanged: (value) =>
                                    setState(() => _endTime = value),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TemplateDropdownField(
                        label: '대상 개체',
                        hintText: '개체 선택',
                        value: _target,
                        items: _targets,
                        onChanged: (value) => setState(() => _target = value),
                      ),
                      ToyVillageTextField(
                        label: '먹이 종류',
                        hintText: '먹이 종류 입력',
                        controller: _feedTypeController,
                      ),
                      _section(
                        '먹이 급여량',
                        FeedAmountField(
                          controller: _amountController,
                          unit: _amountUnit,
                          onUnitChanged: (value) =>
                              setState(() => _amountUnit = value),
                        ),
                      ),
                      ToyVillageTextField(
                        label: '특이사항',
                        hintText: '특이사항 입력',
                        controller: _noteController,
                        scrollPadding: const EdgeInsets.only(bottom: 100),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: ToyVillageButton(label: '작성 완료하기', onTap: _complete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
