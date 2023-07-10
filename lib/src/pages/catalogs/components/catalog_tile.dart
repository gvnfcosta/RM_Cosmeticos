import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/user_list.dart';
import 'package:rm/src/models/user_model.dart';
import 'package:rm/src/pages/catalogs_products/catalogs_products_page.dart';
import 'package:rm/src/pages/catalogs_products/catalog_admin_page.dart';
import '../../../models/catalog_model.dart';
import '/src/services/utils_services.dart';

final UtilsServices utilsServices = UtilsServices();

class CatalogTile extends StatelessWidget {
  const CatalogTile({super.key, required this.catalog});
  final CatalogModel catalog;

  @override
  Widget build(BuildContext context) {
    bool isAdmin = false;
    List<UserModel> user = Provider.of<UserList>(context).user;
    if (user.isNotEmpty) {
      isAdmin = user.first.level == 0;
    }
    return Card(
      elevation: 6,
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) {
                return isAdmin
                    ? CatalogAdminPage(catalog: catalog)
                    : CatalogProductsPage(catalog);
              },
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isAdmin
                    ? [
                        Text(
                          catalog.seller,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.deepOrange),
                        ),
                      ]
                    : []),
            const SizedBox(height: 5),
            Expanded(
              child: SizedBox(
                child: Image.asset('assets/images/CatalogoFace.png'),
              ),
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    color: Colors.pink[400],
                    child: Text(
                      catalog.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w200,
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
