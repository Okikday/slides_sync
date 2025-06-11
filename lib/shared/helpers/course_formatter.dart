class CourseFormatter {
  /// Returns [CourseTitle, CourseCode]
  static ({String courseName, String courseCode}) separateCodeFromTitle(
    String joinedStr,
  ) {
    final regex = RegExp(r'^\*\[([^\]]+)\]\*(.*)');
    final match = regex.firstMatch(joinedStr);

    if (match != null) {
      final courseCode = match.group(1)?.trim();
      final courseTitle = match.group(2)?.trim();
      if (courseCode == null || courseCode.isEmpty) {
        return (courseName: joinedStr, courseCode: "");
      }

      return (courseName: courseTitle ?? "", courseCode: courseCode);
    } else {
      return (courseName: joinedStr, courseCode: "");
    }
  }

  static String joinCodeToTitle(String courseCode, String courseName) {
    if (courseCode.isEmpty || courseCode.length < 2) return courseName;
    return "*[$courseCode]* $courseName";
  }
}
