import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/homework.dart';
import 'package:lms_app/screens/check_homework/homework_detailed_screen.dart';
import 'package:lms_app/utils/next_screen.dart';

class HomeworksListScreen extends StatelessWidget {
  final Course course;

  const HomeworksListScreen({required this.course});

  Future<List<HomeworkLesson>> fetchHomeworks() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('courses/${course.id}/homeworks')
        .where('is_checked', isEqualTo: false)
        .get();

    return snapshot.docs.map((doc) => HomeworkLesson.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("homework-checking".tr()),
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.white,
            ),
      ),
      body: FutureBuilder<List<HomeworkLesson>>(
        future: fetchHomeworks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('no-homeworks-found'.tr()));
          }

          final homeworks = snapshot.data!;
          return ListView.builder(
            itemCount: homeworks.length,
            itemBuilder: (context, index) {
              final homework = homeworks[index];
              return ListTile(
                title: Text(homework.text_solution),
                subtitle: Text(homework.solution_link),
                onTap: () => NextScreen.openBottomSheet(
                  context,
                  HomeworkDetailScreen(homework: homework, course: course,)
                ),
              );
            },
          );
        },
      ),
    );
  }
}
