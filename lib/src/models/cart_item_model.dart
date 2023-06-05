import 'product_model.dart';

class CartItemModel {
  Product product;
  int quantity;

  CartItemModel({
    required this.product,
    required this.quantity,
  });

//  totalPrice() => product.price * quantity;
}
