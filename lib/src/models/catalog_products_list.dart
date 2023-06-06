import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import 'catalog_products_model.dart';

class CatalogProductsList with ChangeNotifier {
  final String _token;
  List<CatalogProducts> items2 = [];

  List<CatalogProducts> get items => [...items2];
  List<CatalogProducts> get product => items2.toList();

  CatalogProductsList(this._token, this.items2);

  int get itemsCount => items2.length;

  Future<void> loadProducts(String path) async {
    items2.clear();

    final response = await http.get(
        Uri.parse('${Constants.baseUrl}/$path/products.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items2.add(
        CatalogProducts(
          id: dataId,
          productId: dataDados['productId'],
          price: dataDados['price'],
          show: dataDados['show'],
        ),
      );
    });
  }

  Future<void> saveProduct(Map<String, Object> dataDados, String path) {
    bool hasId = dataDados['id'] != null;
    double idAleatorio = Random().nextDouble() * 100000;

    final product = CatalogProducts(
      id: hasId ? dataDados['id'] as String : idAleatorio.toString(),
      productId: dataDados['productId'] as String,
      price: dataDados['price'] as double,
      show: dataDados['show'] as bool,
    );

    if (hasId) {
      return updateProduct(product, path);
    } else {
      return addProduct(product, path);
    }
  }

  Future<void> addProduct(CatalogProducts product, String path) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/$path/products.json?auth=$_token'),
      body: jsonEncode({
        'id': product.id,
        'productId': product.productId,
        'price': product.price,
        'show': product.show,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items2.add(
      CatalogProducts(
        id: id,
        productId: product.productId,
        price: product.price,
        show: product.show,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(CatalogProducts product, String path) async {
    int index = items2.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.baseUrl}/$path/products.json?auth=$_token'),
        body: jsonEncode({
          'productId': product.productId,
          'price': product.price,
          'show': product.show,
        }),
      );

      items2[index] = product;
      notifyListeners();
    }
  }

  // Future<void> removeProduct(Product product) async {
  //   int index = items2.indexWhere((p) => p.id == product.id);

  //   if (index >= 0) {
  //     final product = items2[index];
  //     items2.remove(product);
  //     notifyListeners();

  //     final response = await http.delete(
  //       Uri.parse('${Constants.baseUrl}/products.json?auth=$_token'),
  //     );

  //     if (response.statusCode >= 400) {
  //       items2.insert(index, product);
  //       notifyListeners();

  //       throw HttpException('Não foi possível excluir ${product.name}.');
  //     }
  //   }
  // }
}
