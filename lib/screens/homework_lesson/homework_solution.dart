import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:super_editor/super_editor.dart';

class HomeworkSolution extends StatelessWidget {
  const HomeworkSolution({
    super.key,
    required AttributedTextEditingController homeworkController,
    required TextEditingController solutionLinkController,
  })  : _homeworkController = homeworkController,
        _solutionLinkController = solutionLinkController;

  final AttributedTextEditingController _homeworkController;
  final TextEditingController _solutionLinkController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SuperTextField(
                textController: _homeworkController,
                maxLines: 150,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            '-- Или --',
            style: TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            'upload-by-link'.tr(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        TextField(
          controller: _solutionLinkController,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.0),
            ),
            hoverColor: Theme.of(context).primaryColor,
            border: const OutlineInputBorder(),
            hintText: 'enter-link-here'.tr(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            '-- Или --',
            style: TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
          ),
        ),
        const Text(
          'Загрузите изображение с решением',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
