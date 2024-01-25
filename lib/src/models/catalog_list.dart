import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rm/src/models/catalog_products_model.dart';
import '../exceptions/http_exception.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import 'catalog_model.dart';

class CatalogList with ChangeNotifier {
  final String _token;

  List<CatalogModel> _items = [];
  List<CatalogModel> get items => [..._items];
  List<CatalogModel> get lista => _items.toList();

  CatalogList(this._token);

  int get itemsCount => _items.length;

  Future<void> loadData() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/catalog.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    _items = data.entries
        .map<CatalogModel>((entry) =>
            CatalogModel.fromMap(entry.value as Map<String, dynamic>))
        .toList();

    notifyListeners();
  }

  Future<void> saveData(Map<String, Object> dataDados) {
    bool hasId = dataDados['id'] != null;
    double idAleatorio = Random().nextDouble() * 100000;

    final catalog = CatalogModel(
      id: hasId ? dataDados['id'] as String : idAleatorio.toString(),
      name: dataDados['name'] as String,
      seller: dataDados['seller'] as String,
      catalogProducts:
          List<CatalogProducts>.from(dataDados['catalogProducts'] as List),
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
      Uri.parse('${Constants.baseUrl}/catalog.json?auth=$_token'),
      body: jsonEncode(catalog.toMap()),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(catalog.copyWith(id: id));

    notifyListeners();
  }

  Future<void> updateData(CatalogModel catalog) async {
    int index = _items.indexWhere((e) => e.id == catalog.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/catalog/${catalog.id}.json?auth=$_token'),
        body: jsonEncode(catalog.toMap()),
      );

      _items[index] = catalog;
      notifyListeners();
    }
  }

  Future<void> removeData(CatalogModel catalog) async {
    int index = _items.indexWhere((e) => e.id == catalog.id);

    if (index >= 0) {
      final catalog = _items[index];
      _items.remove(catalog);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/catalogs/${catalog.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, catalog);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir esta categoria.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
