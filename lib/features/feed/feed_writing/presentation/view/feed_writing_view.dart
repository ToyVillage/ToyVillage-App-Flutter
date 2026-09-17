import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/feed/feed_info/presentation/view/feed_info_list_view.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/presentation/view_model/animal_feed_logs_view_model.dart';
import 'package:toy_village_app/features/feed/feed_log/presentation/view_model/feed_log_detail_view_model.dart';
import 'package:toy_village_app/features/feed/feed_log/presentation/view_model/feed_log_write_view_model.dart';
import 'package:toy_village_app/features/feed/feed_log/presentation/view_model/my_feed_logs_view_model.dart';
import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_amount_field.dart';
import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_date_field.dart';
import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_time_field.dart';

class FeedWritingView extends ConsumerStatefulWidget {
  final int? animalManageId;
  final int? feedLogId;
  final String? animalName;
  final FeedLogDetail? initial;

  const FeedWritingView({
    super.key,
    this.animalManageId,
    this.feedLogId,
    this.animalName,
    this.initial,
  });

  bool get isEdit => feedLogId != null;

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
    final initial = widget.initial;
    if (initial == null) return;
    final dateTime = initial.feedDateTime;
    _date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final isPm = dateTime.hour >= 12;
    var hour = dateTime.hour % 12;
    if (hour == 0) hour = 12;
    _time = (hour: hour, minute: dateTime.minute, isPm: isPm);
    _feedTypeController.text = initial.feedType;
    _amountController.text = formatFeedAmount(initial.feedAmount);
    _noteController.text = initial.significant;
  }

  @override
  void dispose() {
    _feedTypeController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    if (ref.read(feedLogWriteViewModelProvider).isLoading) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    final date = _date;
    final time = _time;
    final feedType = _feedTypeController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    if (date == null || time == null || feedType.isEmpty || amount == null) {
      showTopToast(overlay, '급여 날짜·시간·먹이 종류·급여량을 입력해주세요.', isError: true);
      return;
    }

    final hour = time.isPm
        ? (time.hour == 12 ? 12 : time.hour + 12)
        : (time.hour == 12 ? 0 : time.hour);
    final feedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      time.minute,
    );
    final request = FeedLogRequest(
      feedDateTime: feedDateTime,
      feedType: feedType,
      feedAmount: amount,
      significant: _noteController.text.trim(),
    );

    final notifier = ref.read(feedLogWriteViewModelProvider.notifier);
    final success = widget.isEdit
        ? await notifier.edit(widget.feedLogId!, request)
        : await notifier.create(widget.animalManageId!, request);
    if (!mounted) return;

    if (!success) {
      showTopToast(overlay, '저장에 실패했어요. 다시 시도해주세요.', isError: true);
      return;
    }

    if (widget.isEdit) {
      ref.invalidate(feedLogDetailViewModelProvider(widget.feedLogId!));
    }
    ref.invalidate(animalFeedLogsViewModelProvider);
    ref.invalidate(myFeedLogsViewModelProvider);
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

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(feedLogWriteViewModelProvider).isLoading;

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
                          subTitle: widget.animalName,
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
                  label: widget.isEdit
                      ? (isSaving ? '수정 중...' : '수정 완료하기')
                      : (isSaving ? '저장 중...' : '작성 완료하기'),
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
