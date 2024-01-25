// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rm/src/models/catalog_products_model.dart';

class CatalogModel {
  String id;
  String name;
  String seller;
  double discount;
  List<CatalogProducts> catalogProducts;

  CatalogModel({
    required this.id,
    required this.name,
    required this.seller,
    required this.discount,
    required this.catalogProducts,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'seller': seller,
      'discount': discount,
      'catalogProducts': catalogProducts.map((x) => x.toMap()).toList(),
    };
  }

  factory CatalogModel.fromMap(Map<String, dynamic> map) {
    return CatalogModel(
      id: map['id'] as String,
      name: map['name'] as String,
      seller: map['seller'] as String,
      discount: map['discount'] as double,
      catalogProducts: List<CatalogProducts>.from(
        (map['catalogProducts'] as List<dynamic>).map<CatalogProducts>(
          (x) => CatalogProducts.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CatalogModel.fromJson(String source) =>
      CatalogModel.fromMap(json.decode(source) as Map<String, dynamic>);

  CatalogModel copyWith({
    String? id,
    String? name,
    String? seller,
    double? discount,
    List<CatalogProducts>? catalogProducts,
  }) {
    return CatalogModel(
      id: id ?? this.id,
      name: name ?? this.name,
      seller: seller ?? this.seller,
      discount: discount ?? this.discount,
      catalogProducts: catalogProducts ?? this.catalogProducts,
    );
  }
}
