import 'package:toy_village_app/features/entity_info/data/model/animal_gender.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_taxonomic.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';

class AnimalDetail {
  final int animalManageId;
  final String animalName;
  final AnimalGender animalGender;
  final int birthYear;
  final String? otherInfo;
  final ReportAttachment? animalImage;
  final int animalKindId;
  final String kindName;
  final String scientificName;
  final AnimalTaxonomic animalTaxonomic;
  final String? detailKind;
  final List<String> legalStatuses;

  const AnimalDetail({
    required this.animalManageId,
    required this.animalName,
    required this.animalGender,
    required this.birthYear,
    required this.otherInfo,
    required this.animalImage,
    required this.animalKindId,
    required this.kindName,
    required this.scientificName,
    required this.animalTaxonomic,
    required this.detailKind,
    required this.legalStatuses,
  });

  factory AnimalDetail.fromJson(Map<String, dynamic> json) {
    final image = json['animalImage'];
    return AnimalDetail(
      animalManageId: json['animalManageId'] as int,
      animalName: json['animalName'] as String,
      animalGender: AnimalGender.fromCode(json['animalGender'] as String),
      birthYear: json['birthYear'] as int,
      otherInfo: json['otherInfo'] as String?,
      animalImage: image == null
          ? null
          : ReportAttachment.fromJson(image as Map<String, dynamic>),
      animalKindId: json['animalKindId'] as int,
      kindName: json['kindName'] as String,
      scientificName: json['scientificName'] as String,
      animalTaxonomic: AnimalTaxonomic.fromCode(json['animalTaxonomic'] as String),
      detailKind: json['detailKind'] as String?,
      legalStatuses: (json['legalStatuses'] as List? ?? const [])
          .map((e) => e as String)
          .toList(),
    );
  }
}
