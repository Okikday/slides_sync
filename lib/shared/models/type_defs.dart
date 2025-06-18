typedef ContentRecord<int, CourseSubCollection, CourseTitleRecord> =
    ({int courseDbId, CourseSubCollection collection, ({String courseName, String courseCode}) courseTitle});
typedef CourseTitleRecord<String> = ({String courseName, String courseCode});
