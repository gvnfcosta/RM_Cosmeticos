import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/user_list.dart';
import 'package:rm/src/models/user_model.dart';
import '../models/auth.dart';
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserModel> user = Provider.of<UserList>(context).user;
    String userName = user.first.name;
    bool isAdmin = user.first.level == 0;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Bem vindo ${userName.split(' ')[0]}!'),
            automaticallyImplyLeading: false,
          ),
          Column(
            children: [
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person_2_outlined),
                title: const Text('Administradores'),
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.userForm);
                },
              ),
              const Divider(),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ajuda'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logout();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.authOrHome,
              );
            },
          ),
        ],
      ),
    );
  }
}
