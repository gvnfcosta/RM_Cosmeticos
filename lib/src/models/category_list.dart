import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../exceptions/http_exception.dart';
import '../config/app_data.dart';
import 'category_model.dart';

class CategoryList with ChangeNotifier {
  final String _token;
  List<Category> items_ = [];

  List<Category> get items => [...items_];
  List<Category> get categories => items_.toList();

  CategoryList(this._token, this.items_);

  int get itemsCount => items_.length;

  Future<void> loadCategories() async {
    items_.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/categories.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items_.add(
        Category(
          id: dataId,
          nome: dataDados['nome'],
          imageUrl: dataDados['imageUrl'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveCategories(Map<String, Object> data) {
    bool hasId = data['id'] != null;
    int idAleatorio = Random().nextInt(100);

    final categories = Category(
      id: hasId ? data['id'] as String : idAleatorio.toString(),
      nome: data['nome'] as String,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateCategories(categories);
    } else {
      return addCategories(categories);
    }
  }

  Future<void> addCategories(Category category) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/categories.json?auth=$_token'),
      body: jsonEncode({
        'id': category.id,
        'nome': category.nome,
        'imageUrl': category.imageUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items_.add(
      Category(
        id: id,
        nome: category.nome,
        imageUrl: category.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateCategories(Category category) async {
    int index = items_.indexWhere((p) => p.id == category.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/categories/${category.id}.json?auth=$_token'),
        body: jsonEncode({
          'nome': category.nome,
          'imageUrl': category.imageUrl,
        }),
      );

      items_[index] = category;
      notifyListeners();
    }
  }

  Future<void> removeCategories(Category category) async {
    int index = items_.indexWhere((p) => p.id == category.id);

    if (index >= 0) {
      final category = items_[index];
      items_.remove(category);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/categories/${category.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        items_.insert(index, category);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir esta categoria.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
