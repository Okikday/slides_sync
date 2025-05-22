class CourseFormatter{
  /// Returns [CourseTitle, CourseCode]
  List<String> separateCodeFromTitle(String joinedStr){
    final regex = RegExp(r'^\*\[([^\]]+)\]\*(.*)');
    final match = regex.firstMatch(joinedStr);
    if(match != null){
      final courseCode = match.group(1)?.trim();
      final courseTitle = match.group(2)?.trim();
      if(courseCode == null || courseCode.isEmpty) return [joinedStr];

      return [courseTitle ?? "", courseCode];
    }else{
      return [joinedStr];
    }
  }
}