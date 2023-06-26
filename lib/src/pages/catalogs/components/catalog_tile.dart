import 'package:flutter/material.dart';
import 'package:rm/src/pages/catalogs_products/catalogs_products_page.dart';
import '../../../models/catalog_model.dart';
import '/src/services/utils_services.dart';

final UtilsServices utilsServices = UtilsServices();
Color corCartao = Colors.blueGrey.shade50;

class CatalogTile extends StatelessWidget {
  const CatalogTile({super.key, required this.catalog});
  final CatalogModel catalog;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
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
              SizedBox(
                height: 180,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/CatalogoFace.png',
                  ),
                ),
              ),
              Text(
                catalog.name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
