import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/word_util.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/file/attachment_section.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/section_divider.dart';
import 'package:toy_village_app/features/notice/presentation/view_model/notice_detail_view_model.dart';
import 'package:toy_village_app/features/notice/presentation/widget/notice_title.dart';

class NoticeDetailView extends ConsumerWidget {
  final int id;

  const NoticeDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
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
              const SectionDivider(),
              Text(breakByWord(value.content), style: ToyVillageTextStyle.body5),
              if (value.files.isNotEmpty) ...[
                const SectionDivider(),
                AttachmentSection(
                  files: value.files
                      .map((f) => (fileName: f.fileName, fileKey: f.fileKey))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
