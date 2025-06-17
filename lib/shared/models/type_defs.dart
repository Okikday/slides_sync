typedef ContentRecord<int, CourseSubCollection, CourseTitleRecord> =
    ({int courseDbId, CourseSubCollection collection, ({String courseName, String courseCode}) courseTitle});
typedef CourseTitleRecord<Record> = ({String courseName, String courseCode});
