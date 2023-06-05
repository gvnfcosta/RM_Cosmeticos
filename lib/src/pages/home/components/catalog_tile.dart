import 'package:flutter/material.dart';
import '../../../catalog/new_catalog_page.dart';
import '../../../models/catalog_model.dart';
import '../../../utils/app_routes.dart';
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
        child: Row(
          children: [
            Expanded(
              child: Text(
                catalog.name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
            ),
            Expanded(
              child: Text(
                catalog.seller,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) {
                        return NewCatalogPage(catalog);
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.note_add, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
