import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/file/file_add_box.dart';
import 'package:toy_village_app/core/widgets/file/file_attachment.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';

class AttachmentEditor extends StatelessWidget {
  final List<ReportAttachment> files;
  final VoidCallback onAdd;
  final void Function(int index) onDelete;
  final bool uploading;

  const AttachmentEditor({
    super.key,
    required this.files,
    required this.onAdd,
    required this.onDelete,
    this.uploading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty && !uploading) return FileAddBox(onTap: onAdd);

    final uploadingCount = uploading ? 1 : 0;
    final showAddCell = files.isNotEmpty;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: files.length + uploadingCount + (showAddCell ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 60,
      ),
      itemBuilder: (context, index) {
        if (showAddCell && index == files.length + uploadingCount) {
          return _AddMoreCell(onTap: onAdd);
        }
        if (uploading && index == files.length) return const _LoadingCell();
        final file = files[index];
        return FileAttachment(
          fileName: file.fileName,
          onDelete: () => onDelete(index),
        );
      },
    );
  }
}

class _LoadingCell extends StatelessWidget {
  const _LoadingCell();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ToyVillageColor.gray60),
      ),
      child: const Center(child: _LoadingContent()),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: ToyVillageColor.gray60,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '로딩 중',
          style: ToyVillageTextStyle.button4.copyWith(
            color: ToyVillageColor.gray60,
          ),
        ),
      ],
    );
  }
}

class _AddMoreCell extends StatelessWidget {
  final VoidCallback onTap;

  const _AddMoreCell({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.centerLeft,
      child: SizedBox(
        width: 120,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: ToyVillageColor.gray60),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 24, color: ToyVillageColor.gray60),
                  const SizedBox(width: 4),
                  Text(
                    '추가하기',
                    style: ToyVillageTextStyle.button4.copyWith(
                      color: ToyVillageColor.gray60,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
