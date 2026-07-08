import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/word_util.dart';
import 'package:toy_village_app/core/widgets/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/features/notice/presentation/view_model/notice_detail_view_model.dart';
import 'package:toy_village_app/features/notice/presentation/widget/file_attachment.dart';
import 'package:toy_village_app/features/notice/presentation/widget/notice_title.dart';

class NoticeDetailView extends ConsumerWidget {
  final int id;

  const NoticeDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: 서버 연동 시 첨부파일 목록으로 교체
    final List<String> files = [
      '당일 지침.pdf',
      '휴관안내.jpg',
      '휴관안내.png',
    ];

    return Scaffold(
      appBar: ToyVillageAppBar(closeIcon: true),
      body: CustomAsyncValue(
        value: ref.watch(noticeDetailViewModelProvider(id)),
        errorMessage: '공지사항을 불러오지 못했어요.',
        data: (value) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NoticeTitle(
                  title: value.title,
                  kind: value.kind,
                  time: value.createdAt,
                ),
                const _NoticeDivider(),
                Text(
                  breakByWord(value.content),
                  style: ToyVillageTextStyle.body5,
                ),
                if (files.isNotEmpty) ...[
                  const _NoticeDivider(),
                  Text('첨부파일', style: ToyVillageTextStyle.subTitle4),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: files.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 60,
                    ),
                    itemBuilder: (context, index) => FileAttachment(
                      fileName: files[index],
                      onDownload: () {},
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
    );
  }
}

class _NoticeDivider extends StatelessWidget {
  const _NoticeDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Divider(thickness: 1, color: ToyVillageColor.gray60),
    );
  }
}
