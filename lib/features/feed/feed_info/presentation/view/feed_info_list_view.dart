import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/pull_to_refresh.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/empty_view.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/presentation/view_model/animal_feed_logs_view_model.dart';

class FeedInfoListView extends ConsumerWidget {
  final int animalManageId;
  final String animalName;

  const FeedInfoListView({
    super.key,
    required this.animalManageId,
    required this.animalName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true, title: '최근 먹이 급여'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomAsyncValue(
            value: ref.watch(animalFeedLogsViewModelProvider(animalManageId)),
            onRetry: () =>
                ref.invalidate(animalFeedLogsViewModelProvider(animalManageId)),
            data: (logs) => PullToRefresh(
              onRefresh: () async => ref.refresh(
                animalFeedLogsViewModelProvider(animalManageId).future,
              ),
              slivers: [
                if (logs.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: EmptyView(message: '급여 기록이 없어요.'),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    sliver: SliverList.separated(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return _FeedLogCard(
                          log: log,
                          onTap: () => context.push(
                            '/feed-info/detail',
                            extra: log.feedLogId,
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
      ),
    );
  }
}

String formatFeedAmount(double amount) {
  if (amount == amount.roundToDouble()) return amount.toInt().toString();
  return amount.toString();
}

String formatFeedTime(DateTime dateTime) {
  return '${_two(dateTime.hour)}:${_two(dateTime.minute)}';
}

String _two(int value) => value.toString().padLeft(2, '0');

class _FeedLogCard extends StatelessWidget {
  final FeedLog log;
  final VoidCallback? onTap;

  const _FeedLogCard({required this.log, required this.onTap});

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
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            log.feedType,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ToyVillageTextStyle.subTitle3,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          formatFeedAmount(log.feedAmount),
                          style: ToyVillageTextStyle.body5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatFeedTime(log.feedDateTime),
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
              Text(
                log.significant.isEmpty ? '특이사항이 없습니다.' : log.significant,
                style: log.significant.isEmpty ? ToyVillageTextStyle.caption4.copyWith(color: ToyVillageColor.gray60) : ToyVillageTextStyle.caption3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
