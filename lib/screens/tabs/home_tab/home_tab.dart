import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/components/app_logo.dart';
import 'package:lms_app/configs/app_config.dart';
import 'package:lms_app/configs/font_config.dart';
import 'package:lms_app/screens/tabs/home_tab/top_authors.dart';
import 'package:lms_app/screens/notifications/notifications.dart';
import 'package:lms_app/screens/search/search_view.dart';
import 'package:lms_app/screens/wishlist.dart';
import 'package:lms_app/utils/next_screen.dart';
import '../../../providers/app_settings_provider.dart';
import 'category1_courses.dart';
import 'category2_courses.dart';
import 'category3_courses.dart';
import 'featured_courses.dart';
import 'free_courses.dart';
import 'home_categories.dart';
import 'home_latest_courses.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    return RefreshIndicator.adaptive(
      displacement: 60,
      onRefresh: () async {
        ref.invalidate(featuredCoursesProvider);
        ref.invalidate(homeCategoriesProvider);
        ref.invalidate(freeCoursesProvider);
        ref.invalidate(category1CoursessProvider);
        ref.invalidate(category2CoursessProvider);
        ref.invalidate(category3CoursessProvider);
        ref.invalidate(topAuthorsProvider);
        ref.invalidate(homeLatestCoursesProvider);
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 60,
            flexibleSpace: Container(
              decoration:  const BoxDecoration(
                gradient: AppConfig.appBarGradient       
             ),   ),
            title:  Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.only(top:4.0),
                child: Row(
                  children: [
                    const AppLogo(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Text('Tengri', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.getFont(fontFamily).fontFamily,),),
                          const Text('App', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(250, 193, 49, 1)),),

                        ],
                      ),

                    )
                  ],
                ),
              ),
            ),
            pinned: true,
            floating: true,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: IconButton(
                  // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () {
                    NextScreen.iOS(context, const SearchScreen());
                  },
                  icon: const Icon(FeatherIcons.search, size: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: IconButton(
                  style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () {
                    NextScreen.iOS(context, const Wishlist());
                  },
                  icon: const Icon(FeatherIcons.heart, size: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7, right: 10),
                child: IconButton(
                  // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () {
                    NextScreen.iOS(context, const Notifications());
                  },
                  icon: const Icon(LineIcons.bell),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Visibility(visible: settings?.featured ?? true, child: const FeaturedCourses()),
                Visibility(visible: settings?.categories ?? true, child: const HomeCategories()),
                Visibility(visible: settings?.freeCourses ?? true, child: const FreeCourses()),
                if (settings != null && settings.homeCategory1 != null) Category1Courses(category: settings.homeCategory1!),
                if (settings != null && settings.homeCategory2 != null) Category2Courses(category: settings.homeCategory2!),
                if (settings != null && settings.homeCategory3 != null) Category3Courses(category: settings.homeCategory3!),
                Visibility(visible: settings?.topAuthors ?? true, child: const TopAuthors()),
                Visibility(visible: settings?.latestCourses ?? true, child: const HomeLatestCourses()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
