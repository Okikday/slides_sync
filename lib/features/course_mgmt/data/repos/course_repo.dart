import 'package:slides_sync/data/isar_data/isar_data.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';

class CourseRepo {
  static final IsarData<CourseModel> isar = IsarData.instance<CourseModel>();
  static Future<int> addCourse(CourseModel course) async => await isar.store(course);
  static Future<List<int>> addMultipleCourses(List<CourseModel> courses) async => await isar.storeAll(courses);

  static Future<void> deleteCourse(int courseId) async {
    await isar.deleteById(courseId);
  }

  static Stream<CourseModel?> watchCourseById(int courseId){
    return IsarData.instance<CourseModel>().watchById(courseId);
  }
  

  static Future<List<CourseModel>> getAllCourses() async {
    return IsarData.instance<CourseModel>().getAll();
  }

  static Stream<List<CourseModel>> watchAllCourses(){
    return IsarData.instance<CourseModel>().watchAll();
  }

  static Future<Stream<List<CourseModel>>> watchAllCoursesLazily() async{
    return await IsarData.instance<CourseModel>().watchAllLazily();
  }
}
