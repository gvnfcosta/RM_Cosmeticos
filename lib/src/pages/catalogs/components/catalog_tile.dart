import 'package:flutter/material.dart';
import '../../../models/catalog_model.dart';
import '../catalogs_products_page.dart';
import '/src/services/utils_services.dart';

final UtilsServices utilsServices = UtilsServices();
Color corCartao = Colors.blueGrey.shade50;

class CatalogTile extends StatelessWidget {
  const CatalogTile({super.key, required this.catalog});
  final CatalogModel catalog;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) {
                  return CatalogProductsPage(catalog);
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                catalog.seller,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                catalog.name,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
