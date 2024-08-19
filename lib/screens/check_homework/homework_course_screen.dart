import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/screens/check_homework/author_course_widget.dart';
import 'package:lms_app/services/firebase_service.dart';

final authorCoursesProvider = FutureProvider.autoDispose.family<List<Course>, String>((ref, authorId) async {
  final courses = await FirebaseService().getCoursesByAuthorId(authorId: authorId);
  return courses;
  
});


class HomeworkCourseScreen extends StatelessWidget { 
  
  final UserModel user;

  const HomeworkCourseScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("check_homework_title".tr()),
          backgroundColor: Theme.of(context).primaryColor,
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("select-your-course".tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 80,
                height: 500,
                child: AuthorCoursesForChecking(
                          user: user,
                        ),
              ),
            
            ],
          )
        ],
      ),
    );
  }
}

