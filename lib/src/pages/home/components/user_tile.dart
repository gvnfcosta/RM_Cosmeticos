import 'package:flutter/material.dart';
import '../../../utils/app_routes.dart';
import '/src/services/utils_services.dart';
import '../../../models/user_model.dart';

class UserTile extends StatelessWidget {
  UserTile({super.key, required this.user});

  final UserModel user;
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withAlpha(230),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome
                  Text(user.name, style: const TextStyle(fontSize: 12)),

                  // Email
                  Text(
                    user.email,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.userForm, arguments: user);
              },
              icon: const Icon(Icons.edit, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
