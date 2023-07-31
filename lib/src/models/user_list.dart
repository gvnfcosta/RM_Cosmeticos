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

  List<UserModel> items_;

  List<UserModel> get items => [...items_];

  UserList(this._token, this._email, this.items_);

  int get itemsCount => items_.length;

  UserModel? get firstUser =>
      items_.firstWhereOrNull((element) => element.email == _email);

  int? get userLevel => firstUser?.level;
  bool get isAdmin => userLevel == 0;
  String? get userName => firstUser?.name;

  Future<void> loadData() async {
    items_.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/users.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items_.add(
        UserModel(
          id: dataId,
          name: dataDados['name'],
          email: dataDados['email'],
          password: '123456',
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
      password: dataDados['password'] as String,
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
        'password': user.password,
        'discount': user.discount,
        'level': user.level,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items_.add(
      UserModel(
        id: id,
        name: user.name,
        email: user.email,
        password: user.password,
        discount: user.discount,
        level: user.level,
      ),
    );
    notifyListeners();
  }

  Future<void> updateData(UserModel user) async {
    int index = items_.indexWhere((e) => e.id == user.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.baseUrl}/users/${user.id}.json?auth=$_token'),
        body: jsonEncode({
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'discount': user.discount,
          'level': user.level,
        }),
      );

      items_[index] = user;
      notifyListeners();
    }
  }

  Future<void> removeData(UserModel user) async {
    int index = items_.indexWhere((e) => e.id == user.id);

    if (index >= 0) {
      items_.remove(user);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/users/${user.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        items_.insert(index, user);
        notifyListeners();

        throw HttpException('Não foi possível excluir ${user.name}}.');
      }
    }
  }
}
