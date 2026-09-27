import 'dart:ui';

import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';

enum FileType {
  pdf(label: 'PDF', icon: SvgAssets.pdf, backgroundColor: ToyVillageColor.redBackground),
  jpg(label: 'JPG', icon: SvgAssets.jpg, backgroundColor: ToyVillageColor.yellowBackground),
  png(label: 'PNG', icon: SvgAssets.png, backgroundColor: ToyVillageColor.greenBackground),
  etc(label: 'FILE', icon: SvgAssets.etc, backgroundColor: ToyVillageColor.gray20);

  final String label;
  final String icon;
  final Color backgroundColor;

  const FileType({
    required this.label,
    required this.icon,
    required this.backgroundColor,
  });

  factory FileType.fromFileName(String fileName) {
    final ext = fileName.contains('.')
        ? fileName.split('.').last.toLowerCase()
        : '';

    switch (ext) {
      case 'pdf':
        return FileType.pdf;
      case 'jpg':
      case 'jpeg':
        return FileType.jpg;
      case 'png':
        return FileType.png;
      default:
        return FileType.etc;
    }
  }

  factory FileType.fromType(String type) {
    switch (type.toUpperCase()) {
      case 'PDF': return FileType.pdf;
      case 'JPG':
      case 'JPEG': return FileType.jpg;
      case 'PNG': return FileType.png;
      default: return FileType.etc;
    }
  }
}
