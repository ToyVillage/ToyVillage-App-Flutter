enum QuestionType {
  text('TEXT'),
  multipleChoice('MULTIPLE_CHOICE'),
  checkBox('CHECK_BOX'),
  fileUpload('FILE_UPLOAD');

  final String code;

  const QuestionType(this.code);

  static QuestionType fromCode(String code) {
    switch (code) {
      case 'TEXT':
      case 'SHORT_TEXT':
      case 'LONG_TEXT':
        return QuestionType.text;
      case 'MULTIPLE_CHOICE':
        return QuestionType.multipleChoice;
      case 'CHECK_BOX':
        return QuestionType.checkBox;
      case 'FILE_UPLOAD':
        return QuestionType.fileUpload;
      default:
        return QuestionType.text;
    }
  }
}
