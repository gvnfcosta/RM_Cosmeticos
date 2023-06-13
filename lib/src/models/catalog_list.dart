import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import 'catalog_model.dart';

class CatalogList with ChangeNotifier {
  final String _token;
  final String _seller;

  List<CatalogModel> items_ = [];
  List<CatalogModel> get items => [...items_];
  List<CatalogModel> get lista => items_.toList();

  CatalogList(this._token, this._seller, this.items_);

  int get itemsCount => items_.length;

  Future<void> loadData() async {
    items_.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/catalogs.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items_.add(
        CatalogModel(
          id: dataId,
          name: dataDados['name'],
          seller: dataDados['seller'],
          discount: dataDados['discount'],
        ),
      );
    });
  }

  Future<void> saveData(Map<String, Object> dataDados) {
    bool hasId = dataDados['id'] != null;
    double idAleatorio = Random().nextDouble() * 100000;

    final catalog = CatalogModel(
      id: hasId ? dataDados['id'] as String : idAleatorio.toString(),
      name: dataDados['name'] as String,
      seller: dataDados['seller'] as String,
      discount: dataDados['discount'] as double,
    );

    if (hasId) {
      return updateData(catalog);
    } else {
      return addData(catalog);
    }
  }

  Future<void> addData(CatalogModel catalog) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/catalogs.json?auth=$_token'),
      body: jsonEncode({
        'id': catalog.id,
        'name': catalog.name,
        'seller': catalog.seller,
        'discount': catalog.discount,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items_.add(
      CatalogModel(
        id: id,
        name: catalog.name,
        seller: catalog.seller,
        discount: catalog.discount,
      ),
    );
    notifyListeners();
  }

  Future<void> updateData(CatalogModel catalog) async {
    int index = items_.indexWhere((e) => e.id == catalog.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/catalogs/${catalog.id}.json?auth=$_token'),
        body: jsonEncode({
          'id': catalog.id,
          'name': catalog.name,
          'seller': catalog.seller,
          'discount': catalog.discount,
        }),
      );

      items_[index] = catalog;
      notifyListeners();
    }
  }

  Future<void> removeData(CatalogModel catalog) async {
    int index = items_.indexWhere((e) => e.id == catalog.id);

    if (index >= 0) {
      items_.remove(catalog);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/catalogs/${catalog.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        items_.insert(index, catalog);
        notifyListeners();

        throw const HttpException('Não foi possível excluir o Catálogo}.');
      }
    }
  }
}
