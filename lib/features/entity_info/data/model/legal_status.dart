class LegalStatus {
  final int? animalLegalStatusId;
  final String kind;

  const LegalStatus({required this.animalLegalStatusId, required this.kind});

  factory LegalStatus.fromJson(Map<String, dynamic> json) {
    return LegalStatus(
      animalLegalStatusId: json['animalLegalStatusId'] as int?,
      kind: json['kind'] as String,
    );
  }
}
