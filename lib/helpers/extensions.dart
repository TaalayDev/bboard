extension StringExt on String {
  String maxLength(int length) {
    if (this.length < length) return this;

    return substring(0, length).replaceRange(length - 3, length, '...');
  }
}
