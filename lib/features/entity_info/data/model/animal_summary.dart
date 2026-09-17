import 'package:toy_village_app/features/entity_info/data/model/animal_gender.dart';

class AnimalSummary {
  final int animalManageId;
  final String animalName;
  final AnimalGender animalGender;
  final int birthYear;

  const AnimalSummary({
    required this.animalManageId,
    required this.animalName,
    required this.animalGender,
    required this.birthYear,
  });

  factory AnimalSummary.fromJson(Map<String, dynamic> json) {
    return AnimalSummary(
      animalManageId: json['animalManageId'] as int,
      animalName: json['animalName'] as String,
      animalGender: AnimalGender.fromCode(json['animalGender'] as String),
      birthYear: json['birthYear'] as int,
    );
  }
}
