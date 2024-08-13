import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/lesson.dart';
import 'package:lms_app/models/question.dart';
import 'package:lms_app/screens/quiz_lesson/question_tile.dart';
import 'package:lms_app/screens/quiz_lesson/quiz_complete.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'package:lms_app/utils/snackbars.dart';
import 'package:secure_content/secure_content.dart';


final selectedOptionProvider = StateProvider.autoDispose<int?>((ref) => null);
final questionPageControllerProvider = Provider((ref) => PageController(initialPage: 0));
final correctAnswerCountProvider = StateProvider<int>((ref) => 0);
final currentPageIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class QuizLesson extends ConsumerStatefulWidget {
  const QuizLesson({super.key, required this.lesson, required this.course});

  final Course course;
  final Lesson lesson;

  @override
  ConsumerState<QuizLesson> createState() => _QuizLessonState();
}


class _QuizLessonState extends ConsumerState<QuizLesson> {
  @override
  Widget build(BuildContext context) {
    final List<Question> questions = widget.lesson.questions ?? [];
    final pageController = ref.watch(questionPageControllerProvider);
    final selectedOption = ref.watch(selectedOptionProvider);
    final currentPageIndex = ref.watch(currentPageIndexProvider);

    return SecureWidget(
              
       builder: (BuildContext context, void Function() onInit, void Function() onDispose) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(widget.lesson.name),
            titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          bottomNavigationBar: BottomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _onNextBtnPressed(context, selectedOption, currentPageIndex, questions, ref, pageController),
              child: Text('next',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )).tr(),
            ),
          ),
          body: PageView.builder(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: questions.length,
            onPageChanged: (value) => ref.read(currentPageIndexProvider.notifier).update((state) => value),
            itemBuilder: (context, questionIndex) {
              final Question question = questions[questionIndex];
              return QuestionTile(
                ref: ref,
                questions: questions,
                currentPageIndex: currentPageIndex,
                question: question,
                questionIndex: questionIndex,
                selectedOption: selectedOption,
              );
            },
          )), isSecure: true,
    overlayWidgetBuilder: (context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: const SizedBox(),
                ),
                appSwitcherMenuColor: Colors.black,
                protectInAppSwitcherMenu: true,
    );
  }

  void _onNextBtnPressed(
    BuildContext context,
    int? selectedOption,
    int currentPageIndex,
    List<Question> questions,
    WidgetRef ref,
    PageController pageController,
  ) {
    if (selectedOption != null) {
      if ((currentPageIndex + 1) >= questions.length) {
        NextScreen.replaceAnimation(context, QuizComplete(course: widget.course, lesson: widget.lesson));
      } else {
        ref.invalidate(selectedOptionProvider);
        pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    } else {
      openSnackbar(context, "choose-answer".tr());
    }
  }
}
