enum AnimalGender {
  man('MAN', '수컷'),
  woman('WOMAN', '암컷');

  final String code;
  final String label;

  const AnimalGender(this.code, this.label);

  static AnimalGender fromCode(String code) {
    return AnimalGender.values.firstWhere(
      (e) => e.code == code,
      orElse: () => AnimalGender.man,
    );
  }
}
