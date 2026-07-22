class ReservationDetailModel {
  final int id;
  final String reservationName;
  final int leaderCount;
  final int reservationCount;
  final String location;
  final DateTime visitDate;
  final String exitTime;
  final DateTime visitSiteDate;
  final DateTime visitTime;
  final String visitSiteExitTime;
  final int visitSiteCount;

  ReservationDetailModel({
    required this.id,
    required this.reservationName,
    required this.leaderCount,
    required this.reservationCount,
    required this.location,
    required this.visitDate,
    required this.exitTime,
    required this.visitSiteDate,
    required this.visitSiteExitTime,
    required this.visitSiteCount,
    required this.visitTime,
  });

  factory ReservationDetailModel.fromJson(Map<String, dynamic> json) {
    return ReservationDetailModel(
      id: json['id'] as int,
      reservationName: json['reservationName'] as String,
      leaderCount: json['leaderCount'] as int,
      reservationCount: json['reservationCount'] as int,
      location: json['location'] as String,
      visitDate: DateTime.parse(json['visitDate'] as String),
      exitTime: json['exitTime'] as String,
      visitSiteDate: DateTime.parse(json['visitSiteDate'] as String),
      visitSiteExitTime: json['visitSiteExitTime'] as String,
      visitSiteCount: json['visitSiteCount'] as int,
      visitTime: DateTime.parse(json['visitTime'] as String),
    );
  }
}
