import 'package:flutter/material.dart';
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Catálogo'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.baseScreen,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.categoryPage,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
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
