import 'package:flutter/material.dart';
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
        child: Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(levels[user.level].toString()),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.userForm, arguments: user);
                    },
                    icon: const Icon(Icons.edit, color: Colors.red),
                  ),
                ],
              ),
              Text(
                user.name,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                user.email,
                style: const TextStyle(
                    fontWeight: FontWeight.w300, color: Colors.blue),
              ),
              const SizedBox(height: 10),
              user.level == 1
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.baseScreen, arguments: user);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text('Catálogos '),
                          Icon(Icons.list, color: Colors.white),
                        ],
                      ))
                  : const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
