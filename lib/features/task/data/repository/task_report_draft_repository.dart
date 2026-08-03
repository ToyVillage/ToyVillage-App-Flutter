import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';

final taskReportDraftRepositoryProvider =
    Provider((ref) => TaskReportDraftRepository());

class TaskReportDraft {
  final String content;
  final String note;
  final List<ReportAttachment> files;

  TaskReportDraft({
    required this.content,
    required this.note,
    required this.files,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    'note': note,
    'files': files.map((f) => f.toJson()).toList(),
  };

  factory TaskReportDraft.fromJson(Map<String, dynamic> json) {
    final files = (json['files'] as List?) ?? const [];
    return TaskReportDraft(
      content: json['content'] as String? ?? '',
      note: json['note'] as String? ?? '',
      files: files
          .map((e) => ReportAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TaskReportDraftRepository {
  String _key(int id) => 'task_report_draft_$id';

  Future<TaskReportDraft?> load(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(id));
    if (raw == null) return null;
    return TaskReportDraft.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(int id, TaskReportDraft draft) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(id), jsonEncode(draft.toJson()));
  }

  Future<void> clear(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(id));
  }
}
