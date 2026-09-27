import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dailyLogDraftRepositoryProvider = Provider(
  (ref) => DailyLogDraftRepository(),
);

class DailyLogDraftRepository {
  String _key(int templateId) => 'daily_log_draft_$templateId';

  Future<void> save(int templateId, Map<String, dynamic> draft) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(templateId), jsonEncode(draft));
  }

  Future<Map<String, dynamic>?> load(int templateId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(templateId));
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clear(int templateId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(templateId));
  }
}
