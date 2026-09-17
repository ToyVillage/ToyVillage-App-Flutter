class PageResult<T> {
  final List<T> content;
  final int totalPages;
  final int totalElements;
  final int number;
  final bool first;
  final bool last;

  const PageResult({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.first,
    required this.last,
  });

  factory PageResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PageResult(
      content: (json['content'] as List? ?? const [])
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['totalPages'] as int? ?? 0,
      totalElements: json['totalElements'] as int? ?? 0,
      number: json['number'] as int? ?? 0,
      first: json['first'] as bool? ?? true,
      last: json['last'] as bool? ?? true,
    );
  }
}
