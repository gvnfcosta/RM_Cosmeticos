import 'package:flutter/material.dart';
import '../../../models/catalog_model.dart';
import '/src/services/utils_services.dart';

class CatalogTile extends StatelessWidget {
  CatalogTile({super.key, required this.catalog});

  final CatalogModel catalog;
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context)
                      //     .pushNamed(AppRoutes.userForm, arguments: user);
                    },
                    icon: const Icon(Icons.edit, color: Colors.red),
                  ),
                ],
              ),
              Text(
                catalog.name,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                catalog.seller,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
