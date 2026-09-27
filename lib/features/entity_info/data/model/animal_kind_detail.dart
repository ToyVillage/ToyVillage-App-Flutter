import 'package:toy_village_app/features/entity_info/data/model/animal_taxonomic.dart';
import 'package:toy_village_app/features/entity_info/data/model/legal_status.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';

class AnimalKindDetail {
  final int animalKindId;
  final String kindName;
  final String? engName;
  final String scientificName;
  final AnimalTaxonomic animalTaxonomic;
  final String? detailKind;
  final List<LegalStatus> legalStatuses;
  final int animalCount;
  final ReportAttachment? kindImage;

  const AnimalKindDetail({
    required this.animalKindId,
    required this.kindName,
    required this.engName,
    required this.scientificName,
    required this.animalTaxonomic,
    required this.detailKind,
    required this.legalStatuses,
    required this.animalCount,
    required this.kindImage,
  });

  factory AnimalKindDetail.fromJson(Map<String, dynamic> json) {
    final image = json['kindImage'];
    return AnimalKindDetail(
      animalKindId: json['animalKindId'] as int,
      kindName: json['kindName'] as String,
      engName: json['engName'] as String?,
      scientificName: json['scientificName'] as String,
      animalTaxonomic: AnimalTaxonomic.fromCode(json['animalTaxonomic'] as String),
      detailKind: json['detailKind'] as String?,
      legalStatuses: (json['legalStatuses'] as List? ?? const [])
          .map((e) => LegalStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      animalCount: json['animalCount'] as int? ?? 0,
      kindImage: image == null
          ? null
          : ReportAttachment.fromJson(image as Map<String, dynamic>),
    );
  }
}
