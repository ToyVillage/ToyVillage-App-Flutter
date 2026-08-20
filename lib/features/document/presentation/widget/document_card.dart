import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/file_util.dart';
import 'package:toy_village_app/features/document/presentation/widget/document_preview_modal.dart';

class DocumentCard extends StatelessWidget {
  final int id;
  final String title;
  final String type;

  const DocumentCard({
    super.key,
    required this.id,
    required this.title,
    required this.type
  });

  @override
  Widget build(BuildContext context) {
    final fileType = FileType.fromType(type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ToyVillageColor.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: fileType.backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(fileType.icon),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 35),
                  child: Text(title, style: ToyVillageTextStyle.heading5),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => showDocumentPreview(
                    context,
                    id: id,
                    title: title,
                    type: type,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: ToyVillageColor.gray60),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Text(
                        '미리보기',
                        style: ToyVillageTextStyle.button5.copyWith(
                          color: ToyVillageColor.gray60,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
