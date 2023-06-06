const List<String> ofertas = ['de Linha', 'em Promoção', 'na Queima'];

const List unidades = ['Un', 'Kit', 'Cx'];

class Constants {
  static const baseUrl = 'https://rmapp-3284d-default-rtdb.firebaseio.com';
  static const catalogUrl =
      'https://rmapp-3284d-default-rtdb.firebaseio.com/sellersCatalogs';
  // static const baseUrl =
  //    'https://rmapp-3284d-default-rtdb.firebaseio.com/${vendedores[0]}/${tipoCatalogo[0]}';

  static const Map<int, String> levels = {
    0: 'Administrador',
    1: 'Vendedor',
    2: 'Cliente',
  };
}
