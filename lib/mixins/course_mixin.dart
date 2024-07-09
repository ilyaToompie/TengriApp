import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/lesson.dart';
import 'package:lms_app/models/user_model.dart';

mixin CourseMixin {

  bool isLessonCompleted(Lesson lesson, UserModel? user) {
    if (user != null && user.completedLessons!.isNotEmpty && user.completedLessons!.any((element) => element.toString().contains(lesson.id))) {
      return true;
    } else {
      return false;
    }
  }
  
  Future<String> homeworkStatus(Lesson lesson, UserModel? user, Course course) async {
  final homeworkCollection = FirebaseFirestore.instance
      .collection('courses')
      .doc(course.id)
      .collection('homeworks');

  final querySnapshot = await homeworkCollection
      .where('uid', isEqualTo: user?.id)
      .where('lesson_id', isEqualTo: lesson.id)
      .get();

  if (querySnapshot.docs.isEmpty) {
    return 'homework-not-found';
  } else {      
    var homeworkDoc = querySnapshot.docs.first;
    var data = homeworkDoc.data();
    if (data['is_checked'] == false) {
      return 'not-checked-yet';
    } else if (data['is_checked'] == true && data['is_approved'] == true) {
      return 'approved';
    } else if (data['is_checked'] == true && data['is_approved'] == false) {
      return 'not-approved';
    } else {
      return 'not-checked-yet';
    }
  }
}


  static String enrollButtonText(Course course, UserModel? user) {
    if (user == null || !user.enrolledCourses!.contains(course.id)) {
      return 'enroll-now';
    } else {
      List validIds = user.completedLessons!.where((element) => element.toString().contains(course.id)).toList();
      final double courseProgess = validIds.isEmpty ? 0 : (validIds.length / course.lessonsCount);
      if (courseProgess == 0) {
        return 'start-course';
      } else if (courseProgess > 0 && courseProgess < 1) {
        return 'continue-course';
      } else {
        return 'restart-course';
      }
    }
  }
}
