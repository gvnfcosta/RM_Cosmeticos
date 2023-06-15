import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import 'product_model.dart';

class ProductList with ChangeNotifier {
  final String _token;
  List<Product> items_ = [];

  List<Product> get items => [...items_];
  //List<Product> get product => items_.toList();

  ProductList(this._token, this.items_);

  int get itemsCount => items_.length;

  Future<void> loadData() async {
    items_.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/products.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items_.add(
        Product(
          id: dataId,
          code: dataDados['code'],
          name: dataDados['name'],
          description: dataDados['description'],
          category: dataDados['category'],
          subCategory: dataDados['subCategory'],
          unit: dataDados['unit'],
          imageUrl: dataDados['imageUrl'],
          show: dataDados['show'],
          // offer: dataDados['offer'],
          // price: dataDados['price'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveData(Map<String, Object> dataDados) {
    bool hasId = dataDados['id'] != null;
    double idAleatorio = Random().nextDouble() * 100000;

    final product = Product(
      id: hasId ? dataDados['id'] as String : idAleatorio.toString(),
      code: dataDados['code'] as String,
      name: dataDados['name'] as String,
      description: dataDados['description'] as String,
      category: dataDados['category'] as String,
      subCategory: dataDados['subCategory'] as String,
      unit: dataDados['unit'] as String,
      imageUrl: dataDados['imageUrl'] as String,
      show: dataDados['show'] as bool,
      // offer: dataDados['offer'] as String,
      // price: dataDados['price'] as double,
    );

    if (hasId) {
      return updateData(product);
    } else {
      return addData(product);
    }
  }

  Future<void> addData(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/products.json?auth=$_token'),
      body: jsonEncode({
        'id': product.id,
        'code': product.code,
        'name': product.name,
        'description': product.description,
        'category': product.category,
        'subCategory': product.subCategory,
        'unit': product.unit,
        'imageUrl': product.imageUrl,
        'show': product.show,
        // 'offer': product.offer,
        // 'price': product.price,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items_.add(
      Product(
        id: id,
        code: product.code,
        name: product.name,
        description: product.description,
        category: product.category,
        subCategory: product.subCategory,
        unit: product.unit,
        imageUrl: product.imageUrl,
        show: product.show,
        // offer: product.offer,
        // price: product.price,
      ),
    );
    notifyListeners();
  }

  Future<void> updateData(Product product) async {
    int index = items_.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/products/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          'code': product.code,
          'name': product.name,
          'description': product.description,
          'category': product.category,
          'subCategory': product.subCategory,
          'unit': product.unit,
          'imageUrl': product.imageUrl,
          'show': product.show,
          // 'offer': product.offer,
          // 'price': product.price,
        }),
      );

      items_[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeData(Product product) async {
    int index = items_.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = items_[index];
      items_.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/products.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        items_.insert(index, product);
        notifyListeners();

        throw HttpException('Não foi possível excluir ${product.name}.');
      }
    }
  }
}
