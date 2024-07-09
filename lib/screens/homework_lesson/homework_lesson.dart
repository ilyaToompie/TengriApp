import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/components/html_body.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/lesson.dart';
import 'package:lms_app/providers/user_data_provider.dart';
import 'package:lms_app/screens/homework_lesson/attach_widget.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/toasts.dart';
import 'package:super_editor/super_editor.dart';

class HomeworkLesson extends ConsumerStatefulWidget {
  const HomeworkLesson({super.key, required this.lesson, required this.course});

  final Course course;
  final Lesson lesson;

  @override
  ConsumerState<HomeworkLesson> createState() => _HomeworkLessonState();

}

class _HomeworkLessonState extends ConsumerState<HomeworkLesson> {
  String description = '';
  String solutionLink = ''; 
  late final AttributedTextEditingController _HomeworkController = AttributedTextEditingController();
  late final TextEditingController _SolutionLinkController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _SolutionLinkController.addListener((){
      solutionLink = _SolutionLinkController.text.toString();

    });
    _HomeworkController.addListener((){
      description = _HomeworkController.text.toString();
    });
  }
 

  

  @override
  Widget build(BuildContext context) {
    
    final user = ref.watch(userDataProvider);

    const String buttonText = 'Отправить решение';
    final IconData icon = Icons.done;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.name),
        titleSpacing: 0,
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
            ),
            onPressed: () async {
             description = _HomeworkController.text.toString();
             solutionLink = _SolutionLinkController.value.toString();
              debugPrint(solutionLink);
              debugPrint(description);
              if (description != '' || solutionLink != ''){
                await FirebaseService().uploadHomework(user!, widget.course, description, solutionLink, widget.lesson);
                Navigator.of(context).pop();
              }
              else{
                openToast('message');
              }
              // await ref.read(userDataProvider.notifier).getData();
            },
          ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Text(
                'exercise'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                color: Theme.of(context).primaryColor,
                  thickness: 3,
                ),
              ),
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: HtmlBody(description: widget.lesson.description.toString(), fontSize: 18,),
              ),
              Text(
                'your-solution'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                    color: Theme.of(context).primaryColor,

                  thickness: 3,
                ),
              ),
              const Text('Запишите ваше решение в поле ниже'),
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.secondary
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SuperTextField(

                      textController: _HomeworkController,
                      maxLines: 150,
                    ),
                  ),
                ),
                

              ),
               const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('-- Или --', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 14),),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text('upload-by-link'.tr(), style: const TextStyle(
                  fontSize: 16
                ),),
              ),
              TextField(
                onChanged:(value) {
                  solutionLink = _SolutionLinkController.text.toString();
                 
                },
                controller: _SolutionLinkController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                  hoverColor: Theme.of(context).primaryColor,
                  border: const OutlineInputBorder(),
                  hintText: 'enter-link-here'.tr(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('-- Или --', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 14),),
              ),
              const Text('Загрузите изображение с решением', style: TextStyle(fontSize: 16),),
             const SizedBox(height: 500, width: 500,child: ImagesPickerWidget(),),
              
              
              //Text('text: $description'),
             
            ],
          ),
        ),
      ),
    );
  }
}

