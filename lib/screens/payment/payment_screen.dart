
import 'dart:io';

import 'package:path/path.dart' as Path;

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/toasts.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyCourseScreen extends StatelessWidget {  
  final Course course;

  const BuyCourseScreen({super.key, required this.course});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Оплата', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
                const SizedBox(height: 50,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(128),
                  child: Image.asset('assets/images/Kaspi_Logo.png', height: 120,)),
                const SizedBox(height: 25,),
                Text('payment-with-kaspi'.tr(), style: Theme.of(context).textTheme.titleLarge,)    
                ,
                SizedBox(
                  height: 100, width: MediaQuery.sizeOf(context).width - 80,
                  child: Text('buy-course-subititle'.tr(args: [course.name]), textAlign: TextAlign.center,)),
                Text('price'.tr(args: [course.price.toString() + "₸"],), style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),

                Text('click-to-go'.tr(), style: Theme.of(context).textTheme.titleSmall,),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 100, width: MediaQuery.sizeOf(context).width - 100,
                  child: 
                    TextField(
                      controller: TextEditingController(text: course.paymentLink),
                      readOnly: true,
                      onTap: () {
                        launchUrl(Uri.parse(course.paymentLink));
                      },    
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                      ),
                    )
                  ),
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            icon: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Icon(
                Icons.copy,
                color: Colors.white,
              ),
            ),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Text(
                'copy-link'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
            ),
            onPressed: () async {
             Clipboard.setData(new ClipboardData(text: course.paymentLink));
             openToast("copied-to-clipboard".tr());
            },
          ),
          const SizedBox(height: 100,),
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            icon: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                'next'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
            ),
            onPressed: () async {
             Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => ImageUploadScreen(course: course)));//course: course));
            },
          ),
            ],
            
            ),
        ],
      ),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  final Course course;

  const ImageUploadScreen({Key? key, required this.course}) : super(key: key);
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_image == null) {
      await PlatformDialog(
        context: context,
        title: 'image-not-selected-title'.tr(),
        content: 'image-not-selected-subtitle'.tr(),
        cancelText: "OK"
      );
      return;
    }

    try {
      print('Uploading image...');
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('payment_checks/${Path.basename(_image!.path)}');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      
      print('Image uploaded. URL: $imageUrl');
      FirebaseService().createPaymentDocument(imageUrl, widget.course);
      print('Document created.');
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload-check-title'.tr(), style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Column(
                  children: [
                    Text('selected-check-title'.tr(), style: Theme.of(context).textTheme.titleLarge,),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: 500, width: 500,
                      child: Image.file(_image!)
                    ),
                  ],
                )
                : Text('no-image-selected'.tr(), textAlign: TextAlign.center,),
            SizedBox(height: 20),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              icon: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  'select-check-image'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
              ),
              onPressed: _pickImage,
            ),
            SizedBox(height: 20),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              icon: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  'send-check'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
              ),
              onPressed: () async {
                await _uploadImageToFirebase();
                if(_image != null){
                await PlatformDialog(
                                  context: context,
                                  title: 'check-uploaded-title'.tr(),
                                  content: 'check-uploaded-subtitle'.tr(),
                                  cancelText: "OK"
                                );
                  Navigator.pop(context);
                }
                
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> PlatformDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? cancelText,
}) async {
  if (Platform.isAndroid) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText!, style: TextStyle(color: Theme.of(context).primaryColor)),
          )
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
        ],
      ),
    );
  }
  return null;
}

