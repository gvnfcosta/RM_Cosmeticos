import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rm/src/utils/app_routes.dart';
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
    if (user.level != 0) corCartao = Colors.green.shade50;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.userForm, arguments: user);
      },
      child: Card(
        //color: corCartao,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListTile(
            leading: SizedBox(
                width: 100,
                child: Text(
                  levels[user.level].toString(),
                  style: const TextStyle(color: Colors.black),
                )),
            title: Text(
              user.name,
              style: const TextStyle(
                  fontSize: 15, color: Colors.red, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              user.email,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
            ),
            trailing: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: FileImage(File('assets/images/avatar.jpg')),
            ),
          ),
        ),
      ),
    );
  }
}
