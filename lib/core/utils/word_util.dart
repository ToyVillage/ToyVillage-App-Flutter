String breakByWord(String text) {
  return text.split(' ').map((word) {
    return word.split('').join('\u2060');
  }).join(' ');
}