import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/user_list.dart';
import 'package:rm/src/models/user_model.dart';
import 'package:rm/src/pages/catalogs/catalogs_page.dart';
import 'package:rm/src/pages/catalogs_products/catalogs_products_page.dart';
import 'package:rm/src/pages/catalogs_products/catalog_admin_page.dart';
import 'package:rm/src/utils/app_routes.dart';
import '../../../models/catalog_model.dart';
import '/src/services/utils_services.dart';

final UtilsServices utilsServices = UtilsServices();

class CatalogTile extends StatelessWidget {
  const CatalogTile({super.key, required this.catalog});
  final CatalogModel catalog;

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = Provider.of<UserList>(context).items;
    UserList? user = Provider.of<UserList>(context);

    final bool _isAdmin = adminController.isAdmin;

    return Stack(
      children: [
        Card(
          elevation: 6,
          color: Colors.white,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) {
                    return _isAdmin
                        ? CatalogAdminPage(catalog: catalog)
                        : CatalogProductsPage(catalog);
                  },
                ),
              );
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  child: _isAdmin
                      ? Container(
                          height: 25,
                          color: Colors.grey[100],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                catalog.seller,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepOrange),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 3),
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
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        color: Colors.pink,
                        child: Text(
                          catalog.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        _isAdmin
            ? Positioned(
                right: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.orangeAccent[200],
                    size: 25,
                  ),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AppRoutes.catalogForm, arguments: catalog),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
