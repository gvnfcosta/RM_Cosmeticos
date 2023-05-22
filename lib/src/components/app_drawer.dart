import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Bem vindo! ${auth.email}'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.categoryPage,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.interests),
            title: const Text('Subcategories'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.subCategoryPage,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Produtos'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.productPage,
              );
            },
          ),
        ],
      ),
    );
  }
}
