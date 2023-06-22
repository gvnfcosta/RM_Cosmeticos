import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import 'catalog_products_model.dart';

class CatalogProductsList with ChangeNotifier {
  final String _token;
  List<CatalogProducts> items_ = [];

  List<CatalogProducts> get items => [...items_];
  List<CatalogProducts> get product => items_.toList();

  CatalogProductsList(this._token, this.items_);

  int get itemsCount => items_.length;

  Future<void> loadData() async {
    items_.clear();

    final response = await http.get(
        Uri.parse('${Constants.baseUrl}/catalog_products.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items_.add(
        CatalogProducts(
          id: dataId,
          productId: dataDados['productId'],
          price: dataDados['price'],
          seller: dataDados['seller'],
          catalog: dataDados['catalog'],
        ),
      );
    });
  }

  Future<void> saveData(Map<String, Object> dataDados) {
    bool hasId = dataDados['id'] != null;
    double idAleatorio = Random().nextDouble() * 100000;

    final product = CatalogProducts(
        id: hasId ? dataDados['id'] as String : idAleatorio.toString(),
        productId: dataDados['productId'] as String,
        price: dataDados['price'] as double,
        seller: dataDados['seller'] as String,
        catalog: dataDados['catalog'] as String);

    if (hasId) {
      return updateData(product);
    } else {
      return addData(product);
    }
  }

  Future<void> addData(CatalogProducts product) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/catalog_products.json?auth=$_token'),
      body: jsonEncode({
        'id': product.id,
        'productId': product.productId,
        'price': product.price,
        'seller': product.seller,
        'catalog': product.catalog,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items_.add(
      CatalogProducts(
        id: id,
        productId: product.productId,
        price: product.price,
        seller: product.seller,
        catalog: product.catalog,
      ),
    );
    notifyListeners();
  }

  Future<void> updateData(CatalogProducts product) async {
    int index = items_.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/catalog_products/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          'productId': product.productId,
          'price': product.price,
          'seller': product.seller,
          'catalog': product.catalog,
        }),
      );

      items_[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeData(CatalogProducts product) async {
    int index = items_.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = items_[index];
      items_.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/catalog_products/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        items_.insert(index, product);
        notifyListeners();

        throw HttpException('Não foi possível excluir ${product.id}.');
      }
    }
  }
}
