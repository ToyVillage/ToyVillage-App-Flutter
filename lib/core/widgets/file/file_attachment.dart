import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/file_util.dart';

class FileAttachment extends StatelessWidget {
  final String fileName;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;

  const FileAttachment({
    super.key,
    required this.fileName,
    this.onDownload,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final fileType = FileType.fromFileName(fileName);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ToyVillageColor.gray60),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(fileType.icon),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ToyVillageTextStyle.button4,
              ),
            ),
            const SizedBox(width: 8),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                tooltip: '삭제',
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                icon: SvgPicture.asset(SvgAssets.delete)
              )
            else
              IconButton(
                onPressed: onDownload,
                tooltip: '다운로드',
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Symbols.download,
                  size: 24,
                  color: ToyVillageColor.gray100,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
