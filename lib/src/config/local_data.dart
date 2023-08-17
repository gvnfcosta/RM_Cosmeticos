// import 'package:hive_flutter/hive_flutter.dart';

// localDados() async {

//   box = createOpenBox();


//   if (box.length == 0) {
//     String email = box.get('email');
//     String password = box.get('password');

//     final Map<String, String> dados = {'email': email, 'password': password};

//     return dados;
//   }
//   return null;
// }

// saveEmail(email, password) async {
//   var box = await Hive.openBox('user_data');

//   // box.deleteFromDisk();
//   // box = await Hive.openBox('user_data');
//   await box.put('email', email);
//   await box.put('password', password);
//   print(box.path);
// }
