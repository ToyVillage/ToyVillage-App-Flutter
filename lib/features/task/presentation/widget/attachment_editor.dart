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

  const AttachmentEditor({
    super.key,
    required this.files,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return FileAddBox(onTap: onAdd);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: files.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 60,
      ),
      itemBuilder: (context, index) {
        if (index == files.length) return _AddMoreCell(onTap: onAdd);
        final file = files[index];
        return FileAttachment(
          fileName: file.fileName,
          onDelete: () => onDelete(index),
        );
      },
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
