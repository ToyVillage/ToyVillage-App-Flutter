import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/file/attachment_section.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';

class EntityNoteView extends StatelessWidget {
  final String entityName;
  final String content;

  const EntityNoteView({
    super.key,
    required this.entityName,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                const ToyVillageReadonlyField(
                  label: '제목',
                  value: '9월 18일 특이사항 일지일지',
                ),
                const SizedBox(height: 20),
                ToyVillageReadonlyField(
                  label: '내용',
                  value: content,
                  minLines: 8,
                ),
                const SizedBox(height: 20),
                const AttachmentSection(
                  files: [
                    (fileName: '특이사항_사진.jpg', fileKey: 'dummy-1'),
                    (fileName: '진료기록.pdf', fileKey: 'dummy-2'),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
