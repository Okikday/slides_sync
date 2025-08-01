import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/data/repos/course_content_repo.dart';

class CreateNoteUc {
  // Algorithm
  // Hold the note as md
  // store the note under the collection
  // store the content
  //

  void createNote(CourseCollection collection, {String defaultNote = '', String title = '', List<String> tags = const []}) async{
    final parentId = collection.collectionId;
    final contentHash = sha256.convert(defaultNote.codeUnits).bytes.toString();
    final path = collection.absolutePath;

    CourseContent newContent = CourseContent.create(
      contentHash: contentHash,
      parentId: parentId,
      title: title,
      description: defaultNote,
      path: FileDetails(filePath: path),
      courseContentType: CourseContentType.note,
      metadataJson: jsonEncode({'tags': tags.toString()}),
    );
    

    await CourseContentRepo.add(newContent);
  }
}
