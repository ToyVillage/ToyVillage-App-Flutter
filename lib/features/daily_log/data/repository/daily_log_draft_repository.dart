import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dailyLogDraftRepositoryProvider = Provider(
  (ref) => DailyLogDraftRepository(),
);

class DailyLogDraft {
  final String? templateName;
  final String content;

  DailyLogDraft({required this.templateName, required this.content});

  Map<String, dynamic> toJson() => {
    'templateName': templateName,
    'content': content,
  };

  factory DailyLogDraft.fromJson(Map<String, dynamic> json) => DailyLogDraft(
    templateName: json['templateName'] as String?,
    content: json['content'] as String? ?? '',
  );

  bool get isEmpty =>
      (templateName == null || templateName!.isEmpty) && content.isEmpty;
}

class DailyLogDraftRepository {
  String _key(int? id) =>
      id == null ? 'daily_log_draft' : 'daily_log_draft_$id';

  Future<DailyLogDraft?> load(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(id));
    if (raw == null) return null;
    try {
      return DailyLogDraft.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await prefs.remove(_key(id));
      return null;
    }
  }

  Future<void> save(int? id, DailyLogDraft draft) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(id), jsonEncode(draft.toJson()));
  }

  Future<void> clear(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(id));
  }
}
