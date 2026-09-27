class CloseDayModel {
  final int id;
  final String title;
  final DateTime startCloseTime;
  final DateTime endCloseTime;

  CloseDayModel({
    required this.id,
    required this.title,
    required this.startCloseTime,
    required this.endCloseTime,
  });

  factory CloseDayModel.fromJson(Map<String, dynamic> json) {
    return CloseDayModel(
      id: json['id'] as int,
      title: json['title'] as String,
      startCloseTime: DateTime.parse(json['startCloseTime'] as String),
      endCloseTime: DateTime.parse(json['endCloseTime'] as String),
    );
  }
}
