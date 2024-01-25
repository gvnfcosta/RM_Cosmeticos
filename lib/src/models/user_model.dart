import 'dart:convert';

import 'package:rm/src/models/catalog_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  String password;
  double discount;
  // List<CatalogModel> catalogs;
  int level;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.discount,
    // required this.catalogs,
    required this.level,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'discount': discount,
      // 'catalogs': catalogs.map((x) => x.toMap()).toList(),
      'level': level,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      discount: map['discount'] as double,
      // catalogs: List<CatalogModel>.from((map['catalogs'] as List<dynamic>)
      //     .map<CatalogModel>(
      //         (x) => CatalogModel.fromMap(x as Map<String, dynamic>))),
      level: map['level'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    double? discount,
    // List<CatalogModel>? catalogs,
    int? level,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      discount: discount ?? this.discount,
      // catalogs: catalogs ?? this.catalogs,
      level: level ?? this.level,
    );
  }
}
