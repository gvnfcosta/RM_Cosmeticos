import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/user_list.dart';
import '../../../utils/app_routes.dart';
import '/src/services/utils_services.dart';
import '../../../models/user_model.dart';

const Map<int, String> levels = {
  0: 'Administrador',
  1: 'Vendedor',
  2: 'Cliente',
};

Color corCartao = Colors.blueGrey.shade50;
final UtilsServices utilsServices = UtilsServices();

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    if (user.level == 0) corCartao = Colors.red.shade50;
    if (user.level == 1) corCartao = Colors.green.shade50;

    return Card(
      color: corCartao,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Text(
              levels[user.level].toString(),
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              user.name,
              style: const TextStyle(
                  fontSize: 18, color: Colors.red, fontWeight: FontWeight.w600),
            ),
            Text(
              user.email,
              style: const TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.userForm, arguments: user);
                  },
                  icon: const Icon(Icons.edit, color: Colors.orange),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                          title: const Text('Excluir Usuário'),
                          content: const Text('Tem certeza?'),
                          actions: [
                            TextButton(
                                child: const Text('NÃO'),
                                onPressed: () => Navigator.of(ctx).pop()),
                            TextButton(
                                child: const Text('SIM'),
                                onPressed: () {
                                  Provider.of<UserList>(context, listen: false)
                                      .removeData(user);
                                  Navigator.of(ctx).pop();
                                }),
                          ]),
                    );
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
