extension StringExtension on String {
  String capitalize() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.capitalize()).join(' ');
  String smallSentence() {
    if (length > 15) {
      return substring(0, 15) + '...';
    } else {
      return this;
    }
  }
  String midSentence() {
    if (length > 25) {
      return substring(0, 25) + '...';
    } else {
      return this;
    }
  }
  String customSentence(int inputLength) {
    if (length > inputLength) {
      return substring(0, inputLength) + '...';
    } else {
      return this;
    }
  }
}