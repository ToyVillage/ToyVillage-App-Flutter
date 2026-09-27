class WorkReportRequest {
  final String content;
  final String? note;
  final List<String>? fileKey;

  const WorkReportRequest({required this.content, this.note, this.fileKey});

  Map<String, dynamic> toJson() => {
    'content': content,
    'note': note,
    'fileKey': fileKey,
  };
}
