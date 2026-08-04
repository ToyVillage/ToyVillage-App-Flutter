class ReportAttachment {
  final String fileName;
  final String fileKey;

  ReportAttachment({required this.fileName, required this.fileKey});

  Map<String, dynamic> toJson() => {'fileName': fileName, 'fileKey': fileKey};

  factory ReportAttachment.fromJson(Map<String, dynamic> json) {
    return ReportAttachment(
      fileName: json['fileName'] as String,
      fileKey: json['fileKey'] as String,
    );
  }
}
