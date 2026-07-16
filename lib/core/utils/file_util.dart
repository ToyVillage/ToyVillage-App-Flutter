import 'dart:ui';

import 'package:toy_village_app/core/constants/color.dart';

enum FileType {
  pdf(label: 'PDF', icon: 'assets/svg/pdf.svg', backgroundColor: ToyVillageColor.redBackground),
  jpg(label: 'JPG', icon: 'assets/svg/jpg.svg', backgroundColor: ToyVillageColor.yellowBackground),
  png(label: 'PNG', icon: 'assets/svg/png.svg', backgroundColor: ToyVillageColor.greenBackground),
  etc(label: 'FILE', icon: 'assets/svg/etc.svg', backgroundColor: ToyVillageColor.gray20);

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
