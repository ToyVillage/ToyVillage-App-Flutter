import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/features/feed/feed_info/presentation/view_model/feed_detail_view_model.dart';
import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_amount_field.dart';
import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_date_field.dart';
import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_time_field.dart';

class FeedWritingView extends ConsumerStatefulWidget {
  final String speciesName;
  final String category;
  final String? entityName;
  final bool isEdit;

  const FeedWritingView({
    super.key,
    required this.speciesName,
    required this.category,
    this.entityName,
    this.isEdit = false,
  });

  @override
  ConsumerState<FeedWritingView> createState() => _FeedWritingViewState();
}

class _FeedWritingViewState extends ConsumerState<FeedWritingView> {
  static const _sectionGap = 16.0;
  static const _labelGap = 12.0;
  static const _scrollBottomGap = 80.0;

  DateTime? _date;
  FeedTime? _time;
  String _amountUnit = feedAmountUnits.first;

  final _feedTypeController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.isEdit) return;
    final detail = ref.read(feedDetailViewModelProvider(widget.speciesName));
    final parts = detail.date.split('.');
    _date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    _time = detail.startTime;
    _amountUnit = detail.unit;
    _feedTypeController.text = detail.feedType;
    _amountController.text = detail.amount;
    _noteController.text = detail.note;
  }

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
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: _scrollBottomGap),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: _sectionGap,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ToyVillageTitle(
                          title: widget.isEdit ? '먹이 급여 수정' : '먹이 급여 작성',
                          subTitle: widget.entityName,
                        ),
                      ),
                      _section(
                        '급여 날짜',
                        FeedDateField(
                          value: _date,
                          onChanged: (value) => setState(() => _date = value),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _section(
                              '급여 시간',
                              FeedTimeField(
                                hintText: '시각 선택',
                                value: _time,
                                onChanged: (value) =>
                                    setState(() => _time = value),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _section(
                              '먹이 급여량',
                              FeedAmountField(
                                controller: _amountController,
                                unit: _amountUnit,
                                onUnitChanged: (value) =>
                                    setState(() => _amountUnit = value),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ToyVillageTextField(
                        label: '먹이 종류',
                        hintText: '먹이 종류 입력',
                        controller: _feedTypeController,
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
                child: ToyVillageButton(
                  label: widget.isEdit ? '수정 완료하기' : '작성 완료하기',
                  onTap: _complete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
