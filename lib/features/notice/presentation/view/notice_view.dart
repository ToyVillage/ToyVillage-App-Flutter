import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/notice/presentation/view_model/notice_view_model.dart';
import 'package:toy_village_app/features/notice/presentation/view_model/read_notice_view_model.dart';
import 'package:toy_village_app/features/notice/presentation/widget/notice_card.dart';
import 'package:toy_village_app/features/notice/presentation/widget/notice_list_skeleton.dart';

class NoticeView extends ConsumerWidget {
  const NoticeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 22),
                child: ToyVillageTitle(
                  title: '공지사항',
                  subTitle: '토이빌리지의 중요한 공지사항',
                ),
              ),
              Expanded(
                child: CustomAsyncValue(
                  value: ref.watch(noticeViewModelProvider),
                  loading: const NoticeListSkeleton(),
                  data: (value) {
                    if (value.isEmpty) {
                      return Center(
                        child: Text(
                          '등록된 공지사항이 없습니다',
                          style: ToyVillageTextStyle.body3.copyWith(
                            color: ToyVillageColor.gray60,
                          ),
                        ),
                      );
                    }
                    final readIds =
                        ref.watch(readNoticeProvider).value ?? <int>{};
                    final hasMore =
                        ref.read(noticeViewModelProvider.notifier).hasMore;
                    return ListView.builder(
                      itemCount: value.length + (hasMore ? 1 : 0),
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= value.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ToyVillageColor.gray60,
                              ),
                            ),
                          );
                        }
                        if (index == value.length - 1) {
                          ref
                              .read(noticeViewModelProvider.notifier)
                              .loadMore();
                        }
                        final notice = value[index];
                        return NoticeCard(
                          kind: notice.kind,
                          title: notice.title,
                          time: notice.createdAt,
                          isRead: readIds.contains(notice.id),
                          onTap: () {
                            ref
                                .read(readNoticeProvider.notifier)
                                .markAsRead(notice.id);
                            context.push('/notice/detail', extra: notice.id);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
