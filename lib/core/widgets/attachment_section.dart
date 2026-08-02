import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/file_download.dart';
import 'package:toy_village_app/core/widgets/file_attachment.dart';

class AttachmentSection extends StatelessWidget {
  final List<({String fileName, String fileKey})> files;

  const AttachmentSection({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          itemBuilder: (context, index) {
            final file = files[index];
            return FileAttachment(
              fileName: file.fileName,
              onDownload: () => downloadFile(
                context,
                fileName: file.fileName,
                fileKey: file.fileKey,
              ),
            );
          },
        ),
      ],
    );
  }
}
