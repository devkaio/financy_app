extension BoolExt on bool {
  int toInt() => this ? 1 : 0;
}

extension StringExt on String {
  bool toBool() => this == 'true' ? true : false;

  String capitalize() {
    if (isEmpty) {
      return this;
    }

    List<String> words = split(' ');

    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      String firstLetter = word[0].toUpperCase();
      String restOfWord = word.substring(1).toLowerCase();
      return '$firstLetter$restOfWord';
    }).toList();

    return capitalizedWords.join(' ');
  }

  String get firstWord => split(' ').first;
}
