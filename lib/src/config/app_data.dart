import '/src/models/user_model.dart';

final products = [];

const List<String> categories = [
  'Kits',
  'Maquiagem',
  'Facial',
  'Capilar',
  'Cremes',
  'Infantil',
];

const List<String> vendedores = ['Maurício', 'Itamar', 'Vendedores'];
const List<String> tipoCatalogo = [
  'Principal',
  'Promoção',
  'Kits',
  'Queima',
  'Maurrr'
];

UserModel user = UserModel(
    id: '1',
    name: 'Giovanni',
    email: 'gvnfcosta@gmail.com',
    discount: 0.00,
    password: '');

class Constants {
  static const baseUrl = 'https://rmapp-3284d-default-rtdb.firebaseio.com';
  //'https://rmapp-3284d-default-rtdb.firebaseio.com/${vendedores[0]}/${tipoCatalogo[0]}';
}
