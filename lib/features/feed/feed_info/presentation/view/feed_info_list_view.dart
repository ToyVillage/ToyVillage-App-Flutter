import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';

class _FeedRecord {
  final String speciesName;
  final String category;
  final String feedType;
  final String amount;
  final String timeRange;
  final String note;

  const _FeedRecord({
    required this.speciesName,
    required this.category,
    required this.feedType,
    required this.amount,
    required this.timeRange,
    required this.note,
  });
}

const _records = <_FeedRecord>[
  _FeedRecord(
    speciesName: '카피바라',
    category: '포유류',
    feedType: '소고기',
    amount: '500 g/ml',
    timeRange: '12:00 ~ 13:00',
    note: '특이사항 칸인데 특이사항이 없습니다.',
  ),
  _FeedRecord(
    speciesName: '카피바라',
    category: '포유류',
    feedType: '건초',
    amount: '1.2 kg/L',
    timeRange: '09:00 ~ 09:30',
    note: '평소보다 잘 먹었습니다.',
  ),
  _FeedRecord(
    speciesName: '카피바라',
    category: '포유류',
    feedType: '사과',
    amount: '200 g/ml',
    timeRange: '15:00 ~ 15:20',
    note: '특이사항이 없습니다.',
  ),
  _FeedRecord(
    speciesName: '카피바라',
    category: '포유류',
    feedType: '당근',
    amount: '300 g/ml',
    timeRange: '18:00 ~ 18:40',
    note: '식욕이 다소 떨어졌습니다.',
  ),
];

class FeedInfoListView extends StatelessWidget {
  const FeedInfoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true, title: '최근 먹이 급여'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final record = _records[index];
                    return _FeedRecordCard(
                      record: record,
                      onTap: () => context.push(
                        '/feed-info/detail',
                        extra: (
                          speciesName: record.speciesName,
                          category: record.category,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedRecordCard extends StatelessWidget {
  final _FeedRecord record;
  final VoidCallback onTap;

  const _FeedRecordCard({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ToyVillageColor.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(record.feedType, style: ToyVillageTextStyle.subTitle3),
                  const SizedBox(width: 7),
                  Text(record.amount, style: ToyVillageTextStyle.body5),
                  const Spacer(),
                  Text(
                    record.timeRange,
                    style: ToyVillageTextStyle.caption4.copyWith(
                      color: ToyVillageColor.gray60,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: ToyVillageColor.gray60),
              ),
              Text(record.note, style: ToyVillageTextStyle.caption3),
            ],
          ),
        ),
      ),
    );
  }
}
