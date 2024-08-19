
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/screens/check_homework/homeworks_list_screen.dart';
import 'package:lms_app/utils/custom_cached_image.dart';
import 'package:lms_app/utils/next_screen.dart';

class GridListCourseTileAuthor extends StatefulWidget {
  const GridListCourseTileAuthor({super.key, required this.course});
  
  final Course course;

  @override
  State<GridListCourseTileAuthor> createState() => _GridListCourseTileAuthorState();
}

class _GridListCourseTileAuthorState extends State<GridListCourseTileAuthor> {
  late String authorId = widget.course.author.id;

  @override
  Widget build(BuildContext context) {
    final heroTag = UniqueKey();
    return Column(
      children: [
        InkWell(
          onTap: () {NextScreen.iOS(context, HomeworksListScreen(course: widget.course));},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 90,
                    width: 100,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
                    child: Hero(tag: heroTag, child: CustomCacheImage(imageUrl: widget.course.thumbnailUrl, radius: 3)),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      //Text('uncheckedHomework',style:  TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                      const SizedBox(height: 5),
                      Text('count-students', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey)).tr(args: [
                        widget.course.studentsCount.toString(),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        const Divider()
      ],
    );
  }
}
