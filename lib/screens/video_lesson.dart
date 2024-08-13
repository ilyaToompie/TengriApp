import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/screens/video_player_screen.dart';
import 'package:secure_content/secure_content.dart';
import '../components/mark_complete_button.dart';
import '../models/course.dart';
import '../models/lesson.dart';

class VideoLesson extends ConsumerStatefulWidget {
  const VideoLesson({super.key, required this.course, required this.lesson});

  final Course course;
  final Lesson lesson;

  @override
  ConsumerState<VideoLesson> createState() => _VideoLessonState();
}

class _VideoLessonState extends ConsumerState<VideoLesson> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SecureWidget(
        overlayWidgetBuilder: (context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: const SizedBox(),
                ),
                appSwitcherMenuColor: Colors.black,
                protectInAppSwitcherMenu: true,
        builder: (BuildContext context, void Function() onInit, void Function() onDispose) => Stack(
          children: [
            
            VideoPlayerScreen(videoUrl: widget.lesson.videoUrl.toString()),
            Align(
              alignment: Alignment.bottomCenter,
              // Visible after 1 sec for video loading time
              child: FutureBuilder(
                future: Future.delayed(const Duration(seconds: 2)),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return MarkCompleteButton(course: widget.course, lesson: widget.lesson);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            )
          ],
        ), isSecure: true,
      ),
    );
  }
}
