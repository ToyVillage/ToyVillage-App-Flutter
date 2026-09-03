import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/features/feed/feed_info/data/model/feed_record.dart';
import 'package:toy_village_app/features/feed/feed_info/presentation/view_model/feed_record_view_model.dart';

class FeedInfoListView extends ConsumerWidget {
  const FeedInfoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(feedRecordViewModelProvider);
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
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
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
  final FeedRecord record;
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
