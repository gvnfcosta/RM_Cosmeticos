import '/src/models/user_model.dart';

final products = [];

List<String> categories = [
  'Kits',
  'Maquiagem',
  'Facial',
  'Capilar',
  'Cremes',
  'Infantil',
];

UserModel user = UserModel(
    name: 'Giovanni',
    nick: 'gvnfcosta@gmail.com',
    discount: 0.00,
    password: '');

class Constants {
  static const baseUrl = 'https://rmapp-3284d-default-rtdb.firebaseio.com';
}
