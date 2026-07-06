enum FileType {
  pdf(label: 'PDF', icon: 'assets/svg/pdf.svg'),
  jpg(label: 'JPG', icon: 'assets/svg/jpg.svg'),
  png(label: 'PNG', icon: 'assets/svg/png.svg'),
  etc(label: 'FILE', icon: 'assets/svg/etc.svg');

  final String label;
  final String icon;

  const FileType({
    required this.label,
    required this.icon,
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
}
