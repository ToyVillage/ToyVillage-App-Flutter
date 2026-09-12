class Assignee {
  final int id;
  final String name;
  final String position;

  const Assignee({
    required this.id,
    required this.name,
    required this.position,
  });

  factory Assignee.fromJson(Map<String, dynamic> json) {
    return Assignee(
      id: json['id'] as int,
      name: json['name'] as String,
      position: json['position'] as String? ?? '',
    );
  }
}
