// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ProductImagePicker extends StatefulWidget {
//   final void Function(File image) onImagePick;

//   const ProductImagePicker({super.key, required this.onImagePick});

//   @override
//   State<ProductImagePicker> createState() => _ProductImagePickerState();
// }

// class _ProductImagePickerState extends State<ProductImagePicker> {
//   File? _image;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 100,
//       maxWidth: 500,
//     );

//     if (pickedImage != null) {
//       setState(() {
//         _image = File(pickedImage.path);
//       });

//       widget.onImagePick(_image!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         CircleAvatar(
//           radius: 150,
//           backgroundColor: Colors.white,
//           backgroundImage: _image != null ? FileImage(_image!) : null,
//         ),
//         TextButton(
//           onPressed: _pickImage,
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.image),
//               SizedBox(width: 10),
//               Text('Adicionar Imagem'),
//             ],
//           ),
//         ),
//         TextButton(
//           onPressed: _pickImage,
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.camera),
//               SizedBox(width: 10),
//               Text('Câmera'),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
