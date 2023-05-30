import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import 'user_model.dart';

class UserList with ChangeNotifier {
  final String _token;
  final String _email;

  List<UserModel> _items = [];

  List<UserModel> get items => [..._items];
  List<UserModel> get user => _items.toList();

  UserList(this._token, this._email, this._items);

  int get itemsCount => _items.length;

  List<UserModel> get usuario =>
      items.where((element) => element.email == _email).toList();

  // Iterable<UserModel> get usuario => items.where((p) => p.id == _userId);

  Future<void> loadData() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/users.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      _items.add(
        UserModel(
          id: dataId,
          name: dataDados['name'],
          email: dataDados['email'],
          discount: dataDados['discount'],
          level: dataDados['level'],
        ),
      );
    });
  }

  Future<void> saveData(Map<String, Object> dataDados) {
    bool hasId = dataDados['id'] != null;
    double idAleatorio = Random().nextDouble() * 100000;

    final user = UserModel(
      id: hasId ? dataDados['id'] as String : idAleatorio.toString(),
      name: dataDados['name'] as String,
      email: dataDados['email'] as String,
      discount: dataDados['discount'] as double,
      level: dataDados['level'] as int,
    );

    if (hasId) {
      return updateData(user);
    } else {
      return addData(user);
    }
  }

  Future<void> addData(UserModel user) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/users.json?auth=$_token'),
      body: jsonEncode({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'discount': user.discount,
        'level': user.level,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(
      UserModel(
        id: id,
        name: user.name,
        email: user.email,
        discount: user.discount,
        level: user.level,
      ),
    );
    notifyListeners();
  }

  Future<void> updateData(UserModel user) async {
    int index = _items.indexWhere((e) => e.id == user.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.baseUrl}/users/${user.id}.json?auth=$_token'),
        body: jsonEncode({
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'discount': user.discount,
          'level': user.level,
        }),
      );

      _items[index] = user;
      notifyListeners();
    }
  }

  Future<void> removeData(UserModel user) async {
    int index = _items.indexWhere((e) => e.id == user.id);

    if (index >= 0) {
      _items.remove(user);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/users/${user.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, user);
        notifyListeners();

        throw HttpException('Não foi possível excluir ${usuario.first.name}}.');
      }
    }
  }
}
