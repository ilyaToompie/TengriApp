import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lms_app/ads/ad_manager.dart';
import 'package:lms_app/constants/app_constants.dart';
import 'package:lms_app/mixins/course_mixin.dart';
import 'package:lms_app/mixins/user_mixin.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/screens/article_lesson.dart';
import 'package:lms_app/screens/auth/login.dart';
import 'package:lms_app/screens/homework_lesson/homework_lesson.dart';
import 'package:lms_app/screens/quiz_lesson/quiz_screen.dart';
import 'package:lms_app/screens/video_lesson.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/loading_widget.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'package:lms_app/utils/snackbars.dart';
import '../../models/lesson.dart';
import '../../providers/user_data_provider.dart';
class Lessons extends ConsumerWidget with CourseMixin, UserMixin {
  const Lessons({super.key, required this.course, required this.sectionId});

  final Course course;
  final String sectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    return FutureBuilder(
      future: FirebaseService().getLessons(course.id, sectionId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicatorWidget();
        }
        List<Lesson> lessons = snapshot.data;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 0, bottom: 20),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final Lesson lesson = lessons[index];
            bool isAccessible = _isLessonAccessible(index, lessons, user);

            return ListTile(
              onTap: isAccessible ? () => _onTap(context, lesson, course, user, ref) : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              horizontalTitleGap: 10,
              title: Text(
                lesson.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: isAccessible ? null : Colors.grey,
                    ),
              ),
              subtitle: Text(lesson.contentType).tr(),
              leading: Text(
                '${index + 1}.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isAccessible
                          ? Theme.of(context).colorScheme.onSecondary
                          : Colors.grey,
                    ),
              ),
              trailing: isAccessible ? _buildTrailingIcon(lesson, user) : Icon(Icons.lock, color: Colors.grey),
            );
          },
        );
      },
    );
  }

  bool _isLessonAccessible(int index, List<Lesson> lessons, UserModel? user) {
    if (index == 0) {
      return true;
    }
    final previousLesson = lessons[index - 1];
    return user?.isLessonCompleted(course.id, previousLesson.id) ?? false;
  }

  void _onTap(BuildContext context, Lesson lesson, Course course, UserModel? user, WidgetRef ref) {
    if (user != null) {
      if (course.priceStatus == priceStatus.keys.first) {
        // Free
        if (hasEnrolled(user, course)) {
          _openLesson(context, lesson, user, ref);
        } else {
          openSnackbar(context, 'Enroll to open lesson');
        }
      } else {
        // Premium
        if (hasEnrolled(user, course) && !UserMixin.isExpired(user)) {
          _openLesson(context, lesson, user, ref);
        } else {
          openSnackbar(context, 'Enroll to open lesson');
        }
      }
    } else {
      NextScreen.openBottomSheet(context, const LoginScreen());
    }
  }

  void _openLesson(BuildContext context, Lesson lesson, UserModel user, WidgetRef ref) async {
    final status = await homeworkStatus(lesson, user, course);
    if (lesson.contentType == 'homework') {
      if (status == 'approved') {
        await showPlatformDialog(
          context: context,
          title: 'Информация',
          content: 'Ваше домашнее задание проверили и оценили на 5',
          cancelText: 'OK',
        );
        return; // Prevent navigation to the next screen
      } else if (status == 'not-checked-yet') {
        final confirmResubmit = await showPlatformDialog(
          context: context,
          title: 'confirmation'.tr(),
          content: 'confirm-deletion-homework'.tr(),
          cancelText: 'cancel'.tr(),
          deleteText: 'delete'.tr(),
        );

        if (confirmResubmit == true) {
          NextScreen.iOS(context, HomeworkLesson(lesson: lesson, course: course));
        }
      } else {
        NextScreen.iOS(context, HomeworkLesson(lesson: lesson, course: course));
      }
    } else if (lesson.contentType == 'video' && lesson.videoUrl != null) {
      NextScreen.iOS(context, VideoLesson(course: course, lesson: lesson));
    } else if (lesson.contentType == 'article') {
      NextScreen.iOS(context, ArticleLesson(lesson: lesson, course: course));
    } else {
      NextScreen.popup(context, QuizLesson(course: course, lesson: lesson));
    }

    // Place interstitial ads when open any lesson
    AdManager.initInterstitailAds(ref);
  }

  Future<String> _homeworkTrailing(Lesson lesson, UserModel user, Course course) async {
    String status = await homeworkStatus(lesson, user, course);
    debugPrint(status);
    return status;
  }

  Widget _buildTrailingIcon(Lesson lesson, UserModel? user) {
    if (lesson.contentType != 'homework') {
      if (isLessonCompleted(lesson, user)) {
        return const Icon(Icons.check_box, color: Colors.orange);
      } else {
        if (lesson.contentType == 'video') {
          return const Icon(FeatherIcons.playCircle);
        } else if (lesson.contentType == 'article') {
          return const Icon(LineIcons.stickyNote);
        } else {
          return const Icon(LineIcons.lightbulb);
        }
      }
    } else {
      if (user == null) {
        return const Icon(LineIcons.eraser);
      }
      return FutureBuilder<String>(
        future: _homeworkTrailing(lesson, user, course),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: Colors.amber,);
          } else if (snapshot.hasError) {
            return const Icon(Icons.error, color: Colors.red);
          } else {
            switch (snapshot.data) {
              case 'homework-not-found':
                return const Icon(LineIcons.home);
              case 'not-checked-yet':
                return const Icon(LineIcons.clock);
              case 'approved':
                return const Icon(Icons.check_box, color: Colors.amber);
              case 'not-approved':
                return const Icon(Icons.restart_alt, color: Colors.red);
              case 'no-user-found':
                return const Icon(Icons.login, color: Colors.red);
              default:
                return const Icon(LineIcons.eraser);
            }
          }
        },
      );
    }
  }
}

Future<bool?> showPlatformDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? cancelText,
  String? deleteText,
}) async {
  if (Platform.isAndroid) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize)),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText, style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(deleteText!, style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  } else if (Platform.isIOS) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText!, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
          ),
          if (deleteText != null)
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(deleteText, style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
  return null;
}
