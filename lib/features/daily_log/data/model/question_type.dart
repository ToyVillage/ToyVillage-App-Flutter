enum QuestionType {
  shortText('SHORT_TEXT'),
  longText('LONG_TEXT'),
  multipleChoice('MULTIPLE_CHOICE'),
  checkBox('CHECK_BOX'),
  dropDown('DROP_DOWN'),
  fileUpload('FILE_UPLOAD');

  final String code;

  const QuestionType(this.code);

  static QuestionType fromCode(String code) {
    for (final type in QuestionType.values) {
      if (type.code == code) return type;
    }
    return QuestionType.shortText;
  }
}
