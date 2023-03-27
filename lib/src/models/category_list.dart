import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../exceptions/http_exception.dart';
import '../config/app_data.dart';
import 'category_model.dart';

class CategoryList with ChangeNotifier {
  final List<Category> _items = [];
  List<Category> get items => [..._items];
  List<Category> get categorias => _items.toList();

  int get itemsCount => _items.length;

  Future<void> loadCategories() async {
    _items.clear();

    final response =
        await http.get(Uri.parse('${Constants.baseUrl}/categorias.json'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      _items.add(
        Category(
          id: dataId,
          nome: dataDados['nome'],
          imageUrl: dataDados['imageUrl'],
        ),
      );
    });
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
      Uri.parse('${Constants.baseUrl}/categorias.json'),
      body: jsonEncode({
        'id': category.id,
        'nome': category.nome,
        'imageUrl': category.imageUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(
      Category(
        id: id,
        nome: category.nome,
        imageUrl: category.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateCategories(Category category) async {
    int index = _items.indexWhere((p) => p.id == category.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.baseUrl}/categorias/${category.id}.json'),
        body: jsonEncode({
          'nome': category.nome,
          'imageUrl': category.imageUrl,
        }),
      );

      _items[index] = category;
      notifyListeners();
    }
  }

  Future<void> removeCategories(Category category) async {
    int index = _items.indexWhere((p) => p.id == category.id);

    if (index >= 0) {
      final category = _items[index];
      _items.remove(category);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/categorias/${category.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, category);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir esta categoria.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
