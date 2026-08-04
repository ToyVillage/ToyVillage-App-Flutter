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
  String _draftKey(int id) => 'task_report_draft_$id';
  String _reportKey(int id) => 'task_report_$id';

  Future<TaskReportDraft?> _load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;
    try {
      return TaskReportDraft.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await prefs.remove(key);
      return null;
    }
  }

  Future<void> _save(String key, TaskReportDraft draft) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(draft.toJson()));
  }

  Future<void> _remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<TaskReportDraft?> load(int id) => _load(_draftKey(id));
  Future<void> save(int id, TaskReportDraft draft) =>
      _save(_draftKey(id), draft);
  Future<void> clear(int id) => _remove(_draftKey(id));

  Future<TaskReportDraft?> loadReport(int id) => _load(_reportKey(id));
  Future<void> saveReport(int id, TaskReportDraft report) =>
      _save(_reportKey(id), report);
  Future<void> clearReport(int id) => _remove(_reportKey(id));
}
