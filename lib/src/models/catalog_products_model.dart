import 'package:flutter/material.dart';

class CatalogProducts with ChangeNotifier {
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
}
