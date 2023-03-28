import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../exceptions/http_exception.dart';
import '../config/app_data.dart';
import 'sub_category_model.dart';

class SubCategoryList with ChangeNotifier {
  final String _token;
  List<SubCategory> _items = [];

  List<SubCategory> get items => [..._items];
  List<SubCategory> get subCategorias => _items.toList();

  SubCategoryList(this._token, this._items);

  int get itemsCount => _items.length;

  Future<void> loadSubCategories() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/subcategorias.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      _items.add(
        SubCategory(
          id: dataId,
          nome: dataDados['nome'],
        ),
      );
    });
  }

  Future<void> saveSubCategories(Map<String, Object> data) {
    bool hasId = data['id'] != null;
    int idAleatorio = Random().nextInt(100);

    final subCategories = SubCategory(
      id: hasId ? data['id'] as String : idAleatorio.toString(),
      nome: data['nome'] as String,
    );

    if (hasId) {
      return _updateDados(subCategories);
    } else {
      return _addDados(subCategories);
    }
  }

  Future<void> _addDados(SubCategory subCategory) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/subcategorias.json?auth=$_token'),
      body: jsonEncode({
        'id': subCategory.id,
        'nome': subCategory.nome,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(
      SubCategory(
        id: id,
        nome: subCategory.nome,
      ),
    );
    notifyListeners();
  }

  Future<void> _updateDados(SubCategory subCategories) async {
    int index = _items.indexWhere((p) => p.id == subCategories.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/subcategorias/${subCategories.id}.json?auth=$_token'),
        body: jsonEncode({
          'nome': subCategories.nome,
        }),
      );

      _items[index] = subCategories;
      notifyListeners();
    }
  }

  Future<void> _removeDados(SubCategory subCategories) async {
    int index = _items.indexWhere((p) => p.id == subCategories.id);

    if (index >= 0) {
      final subCategories = _items[index];
      _items.remove(subCategories);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/subcategorias/${subCategories.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, subCategories);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir esta SubCategoria.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
