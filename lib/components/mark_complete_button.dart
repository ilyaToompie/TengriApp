import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/mixins/course_mixin.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/lesson.dart';
import '../providers/user_data_provider.dart';
import '../services/firebase_service.dart';

class MarkCompleteButton extends ConsumerWidget with CourseMixin {
  const MarkCompleteButton({super.key, required this.course, required this.lesson});

  final Course course;
  final Lesson lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    final bool isCompleted = isLessonCompleted(lesson, user);
    final IconData icon = isCompleted ? Icons.clear : Icons.done;
    final String buttonText = isCompleted ? 'back' : 'mark-complete';

    return BottomAppBar(
      elevation: 0,
      child: Center(
        child: TextButton.icon(
          
          style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor,
),
          icon: Padding(padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6, ), child:  Icon(icon, color: Colors.white,)),
          label: Padding(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6), child: Text(buttonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),).tr(),),
          
          onPressed: () async {
            final navigator = Navigator.of(context);
            if (!isCompleted){
              await FirebaseService().updateLessonMarkComplete(user!, course, lesson);
              await ref.read(userDataProvider.notifier).getData();
            }

            navigator.pop();
          },
        ),
      ),
    );
  }
}
