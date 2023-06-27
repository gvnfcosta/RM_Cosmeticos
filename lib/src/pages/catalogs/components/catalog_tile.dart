import 'package:flutter/material.dart';
import 'package:rm/src/pages/catalogs_products/catalogs_products_page.dart';
import '../../../models/catalog_model.dart';
import '/src/services/utils_services.dart';

final UtilsServices utilsServices = UtilsServices();

class CatalogTile extends StatelessWidget {
  const CatalogTile({super.key, required this.catalog});
  final CatalogModel catalog;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              catalog.seller,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                  color: Colors.grey),
            ),
            Expanded(
              child: SizedBox(
                child: Image.asset('assets/images/CatalogoFace.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    color: Colors.pink[300],
                    child: Text(
                      catalog.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
