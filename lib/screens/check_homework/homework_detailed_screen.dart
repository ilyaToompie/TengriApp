import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/homework.dart';
import 'package:lms_app/services/firebase_service.dart';

class HomeworkDetailScreen extends StatefulWidget {
  final Course course;
  final HomeworkLesson homework;

  const HomeworkDetailScreen({super.key, required this.homework, required this.course});

  @override
  _HomeworkDetailScreenState createState() => _HomeworkDetailScreenState();
}

class _HomeworkDetailScreenState extends State<HomeworkDetailScreen> {
  late double rating;
  late bool isApproved;
  late Future<String> exerciseFuture;

  @override
  void initState() {
    super.initState();
    rating = widget.homework.rate.toDouble();
    isApproved = widget.homework.is_approved;
    exerciseFuture = FirebaseService().fetchExerciseForChecking(widget.homework,  widget.course);
  }

  

  void updateHomework() async {
    await FirebaseFirestore.instance
        .collection('courses/${widget.course.id}/homeworks')
        .doc(widget.homework.id)
        .update({
      'rate': rating.toInt(),
      'is_approved': isApproved,
      'is_checked': true,

    });
    Navigator.pop(context);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'exercise'.tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 3,
              indent: 40,
              endIndent: 40,
            ),
            FutureBuilder<String>(
              future: exerciseFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return Text('no-exercise'.tr());
                } else {
                  return Text(
                    snapshot.data!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  );
                }
              },
            ),
            const SizedBox(height: 50),
            if (widget.homework.text_solution.isNotEmpty)
              Column(
                children: [
                  Text(
                    'solution'.tr(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    thickness: 3,
                    indent: 40,
                    endIndent: 40,
                  ),
                  Text(
                    widget.homework.text_solution,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Text('solution-link-'.tr(args: [widget.homework.solution_link])),
            const SizedBox(height: 20),
            Text('rate-solution'.tr()),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: CheckboxListTile(
                
                activeColor: Theme.of(context).colorScheme.onSecondary,
                title: Text('approve-solution'.tr()),
                value: isApproved,
                onChanged: (value) {
                  setState(() {
                    isApproved = value ?? false;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'submit'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                ).tr(),
              ),
              onPressed: () async {
                updateHomework();
              },
            ),
          ],
        ),
      ),
    );
  }
}
