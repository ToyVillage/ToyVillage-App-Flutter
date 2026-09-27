import 'package:toy_village_app/features/entity_info/data/model/animal_taxonomic.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';

class AnimalKind {
  final int animalKindId;
  final AnimalTaxonomic animalTaxonomic;
  final String kindName;
  final String scientificName;
  final int animalCount;
  final ReportAttachment? kindImage;

  const AnimalKind({
    required this.animalKindId,
    required this.animalTaxonomic,
    required this.kindName,
    required this.scientificName,
    required this.animalCount,
    required this.kindImage,
  });

  factory AnimalKind.fromJson(Map<String, dynamic> json) {
    final image = json['kindImage'];
    return AnimalKind(
      animalKindId: json['animalKindId'] as int,
      animalTaxonomic: AnimalTaxonomic.fromCode(json['animalTaxonomic'] as String),
      kindName: json['kindName'] as String,
      scientificName: json['scientificName'] as String,
      animalCount: json['animalCount'] as int? ?? 0,
      kindImage: image == null
          ? null
          : ReportAttachment.fromJson(image as Map<String, dynamic>),
    );
  }
}

class AnimalKindPage {
  final List<AnimalKind> animalKinds;
  final int totalPageSize;

  const AnimalKindPage({required this.animalKinds, required this.totalPageSize});

  factory AnimalKindPage.fromJson(Map<String, dynamic> json) {
    return AnimalKindPage(
      animalKinds: (json['animalKinds'] as List? ?? const [])
          .map((e) => AnimalKind.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPageSize: json['totalPageSize'] as int? ?? 0,
    );
  }
}
