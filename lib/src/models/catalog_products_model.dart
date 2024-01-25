// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class CatalogProducts {
  String id;
  String productId;
  String seller;
  String catalog;
  int pageNumber;
  int itemNumber;
  double price;

  CatalogProducts({
    required this.id,
    required this.productId,
    required this.seller,
    required this.catalog,
    required this.pageNumber,
    required this.itemNumber,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'seller': seller,
      'catalog': catalog,
      'pageNumber': pageNumber,
      'itemNumber': itemNumber,
      'price': price,
    };
  }

  factory CatalogProducts.fromMap(Map<String, dynamic> map) {
    return CatalogProducts(
      id: map['id'] as String,
      productId: map['productId'] as String,
      seller: map['seller'] as String,
      catalog: map['catalog'] as String,
      pageNumber: map['pageNumber'] as int,
      itemNumber: map['itemNumber'] as int,
      price: map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory CatalogProducts.fromJson(String source) =>
      CatalogProducts.fromMap(json.decode(source) as Map<String, dynamic>);
}
