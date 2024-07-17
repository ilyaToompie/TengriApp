
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/screens/author_profie/author_courses.dart';
import 'package:lms_app/screens/check_homework/grid_list_course_tile.dart';
import 'package:lms_app/utils/loading_widget.dart';

class AuthorCoursesForChecking extends ConsumerWidget {
  const AuthorCoursesForChecking({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesRef = ref.watch(authorCoursesProvider(user.id));
    return coursesRef.when(
      data: (courses) {
        return Column(
          children: [
            Column(
              children: courses
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GridListCourseTileAuthor(course: e),
                    ),
                  )
                  .toList(),
            ),
            Visibility(
              visible: coursesRef.value != null && coursesRef.value!.length >= 3,
              child: Center(
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor,
),
                  onPressed: () {  },
                  child: const Text('view-all', style: TextStyle(color: Colors.white),).tr(),
                  
                ),
              ),
            )
          ],
        );
      },
      error: (error, stackTrace) => Text('error: $error'),
      loading: () => const LoadingIndicatorWidget(),
    );
  }
}

