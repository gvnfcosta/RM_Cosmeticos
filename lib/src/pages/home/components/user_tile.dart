import 'package:flutter/material.dart';
import '../../../utils/app_routes.dart';
import '/src/services/utils_services.dart';
import '../../../models/user_model.dart';

class UserTile extends StatelessWidget {
  UserTile({super.key, required this.user});

  static const Map<int, String> levels = {
    0: 'Administrador',
    1: 'Vendedor',
    2: 'Cliente',
  };

  final UserModel user;
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
                      Navigator.of(context)
                          .pushNamed(AppRoutes.userForm, arguments: user);
                    },
                    icon: const Icon(Icons.edit, color: Colors.red),
                  ),
                ],
              ),
              Text(
                user.name,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                user.email,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.blue),
              ),
              Text(levels[user.level].toString()),
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
                  : const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}
