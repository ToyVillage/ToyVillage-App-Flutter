class OpenTimeModel {
  final int id;
  final DateTime openDate;
  final String startOpenTime;
  final String endOpenTime;

  OpenTimeModel({
    required this.id,
    required this.openDate,
    required this.startOpenTime,
    required this.endOpenTime,
  });

  factory OpenTimeModel.fromJson(Map<String, dynamic> json) {
    return OpenTimeModel(
      id: json['id'] as int,
      openDate: DateTime.parse(json['openDate'] as String),
      startOpenTime: json['startOpenTime'] as String,
      endOpenTime: json['endOpenTime'] as String,
    );
  }

  String get operatingHours => '${_hm(startOpenTime)} ~ ${_hm(endOpenTime)}';

  static String _hm(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return time;
    return '${int.parse(parts[0])}:${parts[1]}';
  }
}
