// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:io';

// class Configuracoes extends StatefulWidget {
//   const Configuracoes({super.key});

//   @override
//   _ConfiguracoesState createState() => _ConfiguracoesState();
// }

//   FirebaseStorage storage = FirebaseStorage.instance;
//   Reference pastaRaiz = storage.ref();
  
// class _ConfiguracoesState extends State<Configuracoes> {
//   final TextEditingController _controllerNome = TextEditingController();



//   XFile? _imagem;
//   String? _idUsuarioLogado;
//   bool _subindoImagem = false;
//   String? _urlImagemRecuperada;

//   Future _recuperarImagem(String origemImagem) async {
//     XFile? imagemSelecionada;
//     switch (origemImagem) {
//       case "camera":
//         imagemSelecionada =
//             await ImagePicker().pickImage(source: ImageSource.camera);
//         break;
//       case "galeria":
//         imagemSelecionada =
//             await ImagePicker().pickImage(source: ImageSource.gallery);
//         break;
//     }

//     setState(() {
//       _imagem = imagemSelecionada;
//       _subindoImagem = true;
//       _uploadImagem();
//     });
//   }

//   Future _uploadImagem() async {
//     FirebaseStorage storage = FirebaseStorage.instance;
//     Reference pastaRaiz = storage.ref();
//     Reference arquivo =
//         pastaRaiz.child("perfil").child("Arquivo.jpg");

//     //Upload da imagem
//     StorageUploadTask task = arquivo.putFile(_imagem);

//     //Controlar progresso do upload
//     task.events.listen((StorageTaskEvent storageEvent) {
//       if (storageEvent.type == StorageTaskEventType.progress) {
//         setState(() {
//           _subindoImagem = true;
//         });
//       } else if (storageEvent.type == StorageTaskEventType.success) {
//         setState(() {
//           _subindoImagem = false;
//         });
//       }
//     });

//     //Recuperar url da imagem
//     task.onComplete.then((StorageTaskSnapshot snapshot) {
//       _recuperarUrlImagem(snapshot);
//     });
//   }

//   Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
//     String url = await snapshot.ref.getDownloadURL();

//     setState(() {
//       _urlImagemRecuperada = url;
//     });
//   }

//   // _recuperarDadosUsuario() async {
//   //   FirebaseAuth auth = FirebaseAuth.instance;
//   //   FirebaseUser usuarioLogado = await auth.currentUser();
//   //   _idUsuarioLogado = usuarioLogado.uid;
//   // }

//   @override
//   void initState() {
//     super.initState();
//     // _recuperarDadosUsuario();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Configurações"),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 _subindoImagem
//                     ? const CircularProgressIndicator()
//                     : Container(),
//                 CircleAvatar(
//                     radius: 100,
//                     backgroundColor: Colors.grey,
//                     backgroundImage: _urlImagemRecuperada != null
//                         ? NetworkImage(_urlImagemRecuperada)
//                         : null),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     TextButton(
//                       child: const Text("Câmera"),
//                       onPressed: () {
//                         _recuperarImagem("camera");
//                       },
//                     ),
//                     TextButton(
//                       child: const Text("Galeria"),
//                       onPressed: () {
//                         _recuperarImagem("galeria");
//                       },
//                     )
//                   ],
//                 ),
//                 // Padding(
//                 //   padding: EdgeInsets.only(bottom: 8),
//                 //   child: TextField(
//                 //     controller: _controllerNome,
//                 //     autofocus: true,
//                 //     keyboardType: TextInputType.text,
//                 //     style: TextStyle(fontSize: 20),
//                 //     decoration: InputDecoration(
//                 //         contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
//                 //         hintText: "Nome",
//                 //         filled: true,
//                 //         fillColor: Colors.white,
//                 //         border: OutlineInputBorder(
//                 //             borderRadius: BorderRadius.circular(32))),
//                 //   ),
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16, bottom: 10),
//                   child: ElevatedButton(
//                       child: const Text(
//                         "Salvar",
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                       // color: Colors.green,
//                       // padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
//                       // shape: RoundedRectangleBorder(
//                       //     borderRadius: BorderRadius.circular(32)),
//                       onPressed: () {}),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
