import 'package:hive_flutter/hive_flutter.dart';

localDados() async {
  var box = await Hive.openBox('user_data');

  String dados = box.get('email');
  return dados;
}

saveEmail(email) async {
  var box = await Hive.openBox('user_data');
  await box.put('email', email);
  print(box.path);
}
