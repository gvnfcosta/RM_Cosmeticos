import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import 'user_model.dart';
import 'package:collection/collection.dart';

class UserList with ChangeNotifier {
  final String _token;
  final String _email;

  List<UserModel> _items;

  List<UserModel> get items => [..._items];

  UserList(this._token, this._email, this._items);

  int get itemsCount => _items.length;

  // List<UserModel> get users =>
  //     _items.where((element) => element.email == _email).first;
  // UserModel? get user =>
  //     _items.where((element) => element.email == _email).first;
  UserModel? get user =>
      _items.firstWhereOrNull((element) => element.email == _email);

  int? get userLevel => user?.level;
  bool get isAdmin => userLevel == 0;
  String? get userName => user?.name;

  String? get userEmail => _email;

  Future<void> loadData() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/users.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dados) {
      _items.add(
        UserModel(
          id: dataId,
          name: dados['name'],
          email: dados['email'],
          discount: dados['discount'],
          level: dados['level'],
        ),
      );
    });

    // _items = data.entries
    //     .map<UserModel>(
    //         (entry) => UserModel.fromMap(entry.value as Map<String, dynamic>))
    //     .toList();
  }

  Future<void> saveData(Map<String, Object> dataDados) {
    bool hasId = dataDados['id'] != null;
    double idAleatorio = Random().nextDouble() * 100000;

    final user = UserModel(
      id: hasId ? dataDados['id'] as String : idAleatorio.toString(),
      name: dataDados['name'] as String,
      email: dataDados['email'] as String,
      // password: dataDados['password'] as String,
      discount: dataDados['discount'] as double,
      // catalogs: [], // List<CatalogModel>.from(dataDados['catalogs'] as List),
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
      body: jsonEncode(user.toMap()),
    );

    final id = jsonDecode(response.body)['name'];

    _items.add(user.copyWith(id: id));

    notifyListeners();
  }

  Future<void> updateData(UserModel user) async {
    int index = _items.indexWhere((e) => e.id == user.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.baseUrl}/users/${user.id}.json?auth=$_token'),
        body: jsonEncode(user.toMap()),
      );

      _items[index] = user;
      notifyListeners();
    }
  }

  Future<void> removeData(UserModel user) async {
    int index = _items.indexWhere((e) => e.id == user.id);

    if (index >= 0) {
      final register = _items[index];
      _items.remove(user);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/users/${register.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, register);
        notifyListeners();

        throw HttpException('Não foi possível excluir ${register.name}.');
      }
    }
  }
}
