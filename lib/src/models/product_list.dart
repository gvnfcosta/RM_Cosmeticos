import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import 'product_model.dart';

class ProductList with ChangeNotifier {
  final String _token;
  List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get product => _items.toList();

  ProductList(this._token, this._items);

  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/products.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      _items.add(
        Product(
          id: dataId,
          code: dataDados['code'],
          name: dataDados['name'],
          description: dataDados['description'],
          category: dataDados['category'],
          price: dataDados['price'],
          unit: dataDados['unit'],
          show: dataDados['show'],
          imageUrl: dataDados['imageUrl'],
        ),
      );
    });
  }

  Future<void> saveProduct(Map<String, Object> dataDados) {
    bool hasId = dataDados['id'] != null;
    double idAleatorio = Random().nextDouble() * 100000;

    final product = Product(
      id: hasId ? dataDados['id'] as String : idAleatorio.toString(),
      code: dataDados['code'] as String,
      name: dataDados['name'] as String,
      description: dataDados['description'] as String,
      category: dataDados['category'] as String,
      price: dataDados['price'] as double,
      unit: dataDados['unit'] as String,
      show: dataDados['show'] as bool,
      imageUrl: dataDados['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/products.json?auth=$_token'),
      body: jsonEncode({
        'id': product.id,
        'code': product.code,
        'name': product.name,
        'description': product.description,
        'category': product.category,
        'price': product.price,
        'unit': product.unit,
        'show': product.show,
        'imageUrl': product.imageUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
        id: id,
        code: product.code,
        name: product.name,
        description: product.description,
        category: product.category,
        price: product.price,
        unit: product.unit,
        show: product.show,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/products/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          'code': product.code,
          'name': product.name,
          'description': product.description,
          'category': product.category,
          'price': product.price,
          'unit': product.unit,
          'show': product.show,
          'imageUrl': product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/products/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();

        throw const HttpException('Não foi possível excluir o produto.');
      }
    }
  }
}
