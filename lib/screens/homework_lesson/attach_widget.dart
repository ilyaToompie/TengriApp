import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ImagesPickerWidget extends StatefulWidget {
const ImagesPickerWidget({super.key});

@override
State<ImagesPickerWidget> createState() => _ImagesPickerWidgetState();
}

class _ImagesPickerWidgetState extends State<ImagesPickerWidget> {
List<File> selectedImages = [];
final picker = ImagePicker();
@override
Widget build(BuildContext context) {
	return Scaffold(
	body: Center(
		child: Column(
		mainAxisAlignment: MainAxisAlignment.center,
		children: [
			const SizedBox(
			height: 20,
			),
			OutlinedButton(
			style: ButtonStyle(

        
      ),
			child: Text('Выберите изображение',style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),),
			onPressed: () {
				getImages();
			},
			),
			Expanded(
			child: SizedBox(
				child: selectedImages.isEmpty
					? null
					: GridView.builder(
            scrollDirection: Axis.horizontal,
						itemCount: selectedImages.length,
						gridDelegate:
							const SliverGridDelegateWithFixedCrossAxisCount(
								crossAxisCount: 1),
						itemBuilder: (BuildContext context, int index) {
						return Padding(
                          padding: const EdgeInsets. symmetric(vertical: 24.0),
                          child: Center(
                            child: kIsWeb
                              ? Image.network(selectedImages[index].path)
                              : Padding(
                                                            padding: const EdgeInsets.only(right: 8.0),
                                                            child: Image.file(selectedImages[index], fit: BoxFit.fill,),
                                                          )),
                        );
						},
					),
			),
			),
		],
		),
	),
	);
}

Future getImages() async {
	final pickedFile = await picker.pickMultiImage(
		imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
	List<XFile> xfilePick = pickedFile;

	setState(
	() {
		if (xfilePick.isNotEmpty) {
		for (var i = 0; i < xfilePick.length; i++) {
			selectedImages.add(File(xfilePick[i].path));
		}
		} else {
		ScaffoldMessenger.of(context).showSnackBar(
			const SnackBar(content: Text('Nothing is selected')));
		}
	},
	);
}
}
