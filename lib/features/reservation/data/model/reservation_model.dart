class ReservationModel {
  final int id;
  final String title;
  final String reservationName;
  final DateTime visitDate;
  final int reservationCount;
  final DateTime reservationDate;

  ReservationModel({
    required this.id,
    required this.title,
    required this.reservationName,
    required this.visitDate,
    required this.reservationCount,
    required this.reservationDate,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      reservationName: json['reservationName'] as String,
      visitDate: DateTime.parse(json['visitDate'] as String),
      reservationCount: json['reservationCount'] as int,
      reservationDate: DateTime.parse(json['reservationDate'] as String),
    );
  }
}
