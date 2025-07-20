
typedef ContentRecord<int, CourseCollection, CourseTitleRecord> =
    ({int courseDbId, CourseCollection collection, ({String courseName, String courseCode}) courseTitle});
typedef CourseTitleRecord<String> = ({String courseName, String courseCode});