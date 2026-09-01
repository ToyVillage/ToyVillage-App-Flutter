import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';
import 'package:toy_village_app/features/task/presentation/widget/attachment_editor.dart';
import 'package:toy_village_app/features/task/presentation/widget/attachment_picker.dart';

class FileUploadField extends ConsumerStatefulWidget {
  final List<ReportAttachment> initialFiles;
  final ValueChanged<List<ReportAttachment>>? onChanged;

  const FileUploadField({
    super.key,
    this.initialFiles = const [],
    this.onChanged,
  });

  @override
  ConsumerState<FileUploadField> createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends ConsumerState<FileUploadField> {
  late final List<ReportAttachment> _files = [...widget.initialFiles];

  Future<void> _add() async {
    final attachment = await pickAndUploadAttachment(context, ref);
    if (attachment == null) return;
    setState(() => _files.add(attachment));
    widget.onChanged?.call(List.unmodifiable(_files));
  }

  void _delete(int index) {
    setState(() => _files.removeAt(index));
    widget.onChanged?.call(List.unmodifiable(_files));
  }

  @override
  Widget build(BuildContext context) {
    return AttachmentEditor(files: _files, onAdd: _add, onDelete: _delete);
  }
}
