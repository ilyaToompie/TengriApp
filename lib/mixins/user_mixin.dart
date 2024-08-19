import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/screens/curricullam_screen.dart';
import 'package:lms_app/screens/home/home_bottom_bar.dart';
import 'package:lms_app/screens/home/home_view.dart';
import 'package:lms_app/screens/intro.dart';
import 'package:lms_app/screens/auth/login.dart';
import 'package:lms_app/screens/payment/payment_screen.dart';
import 'package:lms_app/services/auth_service.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'package:lms_app/utils/snackbars.dart';
import '../providers/user_data_provider.dart';

mixin UserMixin {
  void handleLogout(context, {required WidgetRef ref}) async {
    await AuthService().userLogOut().onError((error, stackTrace) => debugPrint('error: $error'));
    ref.invalidate(userDataProvider);
    ref.invalidate(homeTabControllerProvider);
    ref.invalidate(navBarIndexProvider);
    NextScreen.closeOthersAnimation(context, const IntroScreen());
  }

  bool hasEnrolled(UserModel? user, Course course) {
    if (user != null && user.enrolledCourses != null && user.enrolledCourses!.contains(course.id)) {
      return true;
    } else {
      return false;
    }
  }

  static bool isExpired(UserModel user) {
    final DateTime expireDate = user.subscription!.expireAt;
    final DateTime now = DateTime.now().toUtc();
    final difference = expireDate.difference(now).inDays;
    if (difference >= 0) {
      return false;
    } else {
      return true;
    }
  }

  static bool isUserPremium(UserModel? user) {
    return user != null && user.subscription != null && isExpired(user) == false ? true : false;
  }

  int remainingDays(UserModel user) {
    final DateTime expireDate = user.subscription!.expireAt;
    final DateTime now = DateTime.now().toUtc();
    final difference = expireDate.difference(now).inDays;
    return difference;
  }

  Future handleEnrollment(
    BuildContext context, {
    required UserModel? user,
    required Course course,
    required WidgetRef ref,
  }) async {
    if (user != null) {
      if (course.price == 0) {
        // Free Course
        if (hasEnrolled(user, course)) {
          NextScreen.popup(context, CurriculamScreen(course: course));
        } else {
          //AdManager.initInterstitailAds(ref);
          await _comfirmEnrollment(context, user, course, ref);
        }
      } else {
        //  Premium Course
        if (user.subscription != null && !isExpired(user)) {
          if (hasEnrolled(user, course)) {
            NextScreen.popup(context, CurriculamScreen(course: course));
          } else {
            await _comfirmEnrollment(context, user, course, ref);
          }
        } else {

            NextScreen.openBottomSheet(context, BuyCourseScreen(course: course,), isDismissable: true);

        }
      }
    } else {
      NextScreen.openBottomSheet(context, const LoginScreen(popUpScreen: true));
    }
  }

  Future _comfirmEnrollment(BuildContext context, UserModel user, Course course, WidgetRef ref) async {
    await FirebaseService().updateEnrollment(user, course);
    await FirebaseService().updateStudentCountsOnCourse(true, course.id);
    await FirebaseService().updateStudentCountsOnAuthor(true, course.author.id);
    await ref.read(userDataProvider.notifier).getData();
    if (!context.mounted) return;
    openSnackbar(context, 'Вы были зарегистрированы!');
  }

  Future handleOpenCourse(
    BuildContext context, {
    required UserModel user,
    required Course course,
  }) async {
    if (course.price == 0) {
      NextScreen.popup(context, CurriculamScreen(course: course));
    } else {
      if (!isExpired(user)) {
        NextScreen.popup(context, CurriculamScreen(course: course));
      } else {
        //NextScreen.openBottomSheet(context, const IAPScreen());
      }
    }
  }
}
