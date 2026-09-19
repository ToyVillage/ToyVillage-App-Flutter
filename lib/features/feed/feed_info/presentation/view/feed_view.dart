import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/dropdown/menu_dropdown.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';
import 'package:toy_village_app/features/feed/feed_info/presentation/view/feed_info_list_view.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/presentation/view_model/feed_log_detail_view_model.dart';

class FeedView extends ConsumerWidget {
  final int feedLogId;

  const FeedView({super.key, required this.feedLogId});

  String _dateText(DateTime dateTime) =>
      '${dateTime.year}.${_two(dateTime.month)}.${_two(dateTime.day)}';

  String _timeText(DateTime dateTime) {
    final isPm = dateTime.hour >= 12;
    var hour = dateTime.hour % 12;
    if (hour == 0) hour = 12;
    return '${_two(hour)} : ${_two(dateTime.minute)} ${isPm ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(feedLogDetailViewModelProvider(feedLogId)),
          onRetry: () =>
              ref.invalidate(feedLogDetailViewModelProvider(feedLogId)),
          data: (detail) => RefreshIndicator(
            color: ToyVillageColor.gray100,
            onRefresh: () async =>
                ref.refresh(feedLogDetailViewModelProvider(feedLogId).future),
            child: _content(context, detail),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, FeedLogDetail detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Expanded(child: ToyVillageTitle(title: '먹이 급여 정보')),
                  MenuDropdown(
                    items: [
                      MenuDropdownItem(
                        label: '수정',
                        onTap: () => context.push(
                          '/feed-writing/write',
                          extra: (
                            animalManageId: null,
                            feedLogId: detail.feedLogId,
                            animalName: null,
                            initial: detail,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _section('급여 날짜', _dateBox(_dateText(detail.feedDateTime))),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _section(
                    '급여 시간',
                    _timeBox(_timeText(detail.feedDateTime)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _section(
                    '먹이 급여량',
                    _amountBox(formatFeedAmount(detail.feedAmount)),
                  ),
                ),
              ],
            ),
            ToyVillageReadonlyField(label: '먹이 종류', value: detail.feedType),
            ToyVillageReadonlyField(
              label: '특이사항',
              value: detail.significant,
              minLines: 3,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
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

  Widget _box({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _dateBox(String value) {
    return _box(
      child: Row(
        children: [
          SvgPicture.asset(SvgAssets.dateToday),
          const SizedBox(width: 8),
          Text(
            value,
            style: ToyVillageTextStyle.body5.copyWith(
              color: ToyVillageColor.gray100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String value) {
    return _box(
      child: Row(
        children: [
          SvgPicture.asset(SvgAssets.clock),
          const SizedBox(width: 8),
          Text(
            value,
            style: ToyVillageTextStyle.body5.copyWith(
              color: ToyVillageColor.gray100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountBox(String amount) {
    return _box(
      child: Text(
        amount,
        style: ToyVillageTextStyle.body5.copyWith(
          color: ToyVillageColor.gray100,
        ),
      ),
    );
  }
}

String _two(int value) => value.toString().padLeft(2, '0');
