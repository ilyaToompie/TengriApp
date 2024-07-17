import 'package:cloud_firestore/cloud_firestore.dart';

class HomeworkLesson {
  final String id;
  final String lesson_id;
  final String section_id;
  final String solution_link;
  final String text_solution;
  final String uid;
  final int rate;
  final bool is_approved;
  final bool is_checked;

  HomeworkLesson({
    required this.id,
    required this.uid,
    required this.lesson_id,
    required this.section_id,
    required this.is_approved,
    required this.is_checked,
    required this.rate,
    required this.solution_link,
    required this.text_solution,
  });

  factory HomeworkLesson.fromFirestore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<String, dynamic>;
    return HomeworkLesson(
      id: snap.id,
      uid: d['uid'],
      lesson_id: d['lesson_id'],
      section_id: d['section_id'],
      is_approved: d['is_approved'],
      is_checked: d['is_checked'],
      rate: d['rate'],
      solution_link: d['solution_link'],
      text_solution: d['text_solution'],
    );
  }
}
