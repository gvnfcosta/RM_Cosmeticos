import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:rm/src/config/custom_colors.dart';

class ImageUploads extends StatefulWidget {
  final void Function(File photo) onImagePick;
  final String? image;

  const ImageUploads({
    super.key,
    required this.onImagePick,
    required this.image,
  });
  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  File? _photo;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future imgFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 500,
    );
    if (pickedImage != null) {
      setState(() {
        _photo = File(pickedImage.path);
        // uploadFile();
      });

      widget.onImagePick(_photo!);
    }
  }

  Future imgFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: 500,
    );

    if (pickedImage != null) {
      setState(() {
        _photo = File(pickedImage.path);
        // uploadFile();
      });

      widget.onImagePick(_photo!);
    }
  }

  // Future uploadFile() async {
  //   if (_photo == null) return;
  //   final fileName = basename(_photo!.path);
  //   const destination = 'AppImages/';

  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance
  //         .ref(destination)
  //         .child(fileName);
  //     await ref.putFile(_photo!);
  //   } catch (e) {
  //     print('Ocorreu um erro');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String _image = widget.image! != null ? widget.image! : '';
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: () => _showPicker(context),
              child: CircleAvatar(
                radius: size.height * 0.13,
                backgroundColor: CustomColors.customSwatchColor,
                //backgroundColor: Colors.white,
                child: _photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          _photo!,
                          width: 400,
                          height: 500,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 400,
                        height: 500,
                        child: _image == ''
                            ? const Icon(
                                Icons.camera_alt,
                                size: 100,
                                color: Colors.blueGrey,
                              )
                            : Image.network(_image),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Galeria'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Câmera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
