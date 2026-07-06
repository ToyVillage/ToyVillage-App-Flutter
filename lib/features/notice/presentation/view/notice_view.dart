import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/title.dart';
import 'package:toy_village_app/features/notice/presentation/view_model/notice_view_model.dart';
import 'package:toy_village_app/features/notice/presentation/view_model/read_notice_view_model.dart';
import 'package:toy_village_app/features/notice/presentation/widget/notice_card.dart';

class NoticeView extends ConsumerWidget {
  const NoticeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ToyVillageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToyVillageTitle(
                  title: '공지사항',
                  subTitle: '토이빌리지의 중요한 공지사항'
              ),
              CustomAsyncValue(
                value: ref.watch(noticeViewModelProvider),
                data: (value) {
                  final readIds = ref.watch(readNoticeProvider).value ?? <int>{};
                  return Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 20),
                        itemCount: value.length,
                        itemBuilder: (BuildContext context, int index) {
                          final notice = value[index];
                          return NoticeCard(
                              kind: notice.kind,
                              title: notice.title,
                              time: notice.createAt,
                              isRead: readIds.contains(notice.id),
                              onTap: () {
                                ref
                                    .read(readNoticeProvider.notifier)
                                    .markAsRead(notice.id);
                                context.push('/notice/detail', extra: notice.id);
                              }
                          );
                        }
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
