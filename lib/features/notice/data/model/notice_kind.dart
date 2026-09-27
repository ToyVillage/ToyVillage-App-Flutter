List<String> parseTeamNames(dynamic raw) {
  if (raw is! List) return const [];
  final names = <String>[];
  for (final item in raw) {
    if (item is String) {
      if (item.isNotEmpty) names.add(item);
    } else if (item is Map) {
      final name = item['teamName'] ?? item['name'] ?? item['team'] ?? '';
      if (name is String && name.isNotEmpty) names.add(name);
    }
  }
  return names;
}
