class Formatter {
  static String formatEnumName(String name) {
    return name
        .split(RegExp(r'(?=[A-Z])'))
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}