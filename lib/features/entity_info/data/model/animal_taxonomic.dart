enum AnimalTaxonomic {
  mammals('MAMMALS', '포유류'),
  reptiles('REPTILES', '파충류'),
  fish('FISH', '어류'),
  birds('BIRDS', '조류');

  final String code;
  final String label;

  const AnimalTaxonomic(this.code, this.label);

  static AnimalTaxonomic fromCode(String code) {
    return AnimalTaxonomic.values.firstWhere(
      (e) => e.code == code,
      orElse: () => AnimalTaxonomic.mammals,
    );
  }

  static AnimalTaxonomic fromLabel(String label) {
    return AnimalTaxonomic.values.firstWhere(
      (e) => e.label == label,
      orElse: () => AnimalTaxonomic.mammals,
    );
  }
}
