class ReservationModel {
  final int id;
  final String title;
  final String reservationName;
  final DateTime visitDate;
  final int reservationCount;

  ReservationModel({
    required this.id,
    required this.title,
    required this.reservationName,
    required this.visitDate,
    required this.reservationCount,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      reservationName: json['reservationName'] as String,
      visitDate: DateTime.parse(json['visitDate'] as String),
      reservationCount: json['reservationCount'] as int,
    );
  }
}
