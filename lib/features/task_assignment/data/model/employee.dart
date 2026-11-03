class Employee {
  final int id;
  final String name;
  final String role;

  const Employee({required this.id, required this.name, required this.role});

  bool get isEmployee => role == 'EMPLOYEE';

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }
}
