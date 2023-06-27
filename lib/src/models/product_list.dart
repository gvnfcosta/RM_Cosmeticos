import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import 'product_model.dart';

class ProductList with ChangeNotifier {
  final String _token;
  List<Product> items2;

  List<Product> get items => [...items2];
  List<Product> get products => items2.toList();

  ProductList(this._token, this.items2);

  int get itemsCount => items2.length;

  Future<void> loadData() async {
    items2.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/products.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items2.add(
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
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items2.add(
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
      ),
    );
    notifyListeners();
  }

  Future<void> updateData(Product product) async {
    int index = items2.indexWhere((p) => p.id == product.id);

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
        }),
      );

      items2[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeData(Product product) async {
    int index = items2.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = items2[index];
      items2.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/products.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        items2.insert(index, product);
        notifyListeners();

        throw HttpException('Não foi possível excluir ${product.name}.');
      }
    }
  }
}
