import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/features/document/presentation/view_model/document_detail_view_model.dart';

void showDocumentPreview(
  BuildContext context, {
  required int id,
  required String title,
  required String type,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => _DocumentPreviewModal(id: id, title: title, type: type),
  );
}

class _DocumentPreviewModal extends ConsumerWidget {
  final int id;
  final String title;
  final String type;

  const _DocumentPreviewModal({
    required this.id,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _pillButton(
                    icon: Symbols.download,
                    label: '다운로드',
                    onTap: () {
                      // TODO: 파일 다운로드 연동
                    },
                  ),
                  const SizedBox(width: 8),
                  _iconButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: ToyVillageColor.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: CustomAsyncValue(
                    value: ref.watch(documentDetailViewModelProvider(id)),
                    // TODO: fileKey로 실제 파일(이미지/PDF) 렌더링
                    data: (detail) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(detail.title, style: ToyVillageTextStyle.body3),
                          const SizedBox(height: 12),
                          for (final file in detail.files)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                file.fileName,
                                style: ToyVillageTextStyle.body5.copyWith(
                                  color: ToyVillageColor.gray60,
                                ),
                              ),
                            ),
                        ],
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

  Widget _pillButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: ToyVillageColor.white, size: 24),
            const SizedBox(width: 6),
            Text(
              label,
              style: ToyVillageTextStyle.button4.copyWith(
                color: ToyVillageColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: ToyVillageColor.white, size: 22),
      ),
    );
  }
}
