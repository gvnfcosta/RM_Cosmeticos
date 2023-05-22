import 'package:flutter/material.dart';
import '../../product/products_form_page.dart';
import '/src/config/custom_colors.dart';
import '/src/services/utils_services.dart';
import '../../../models/user_model.dart';

class UserTile extends StatelessWidget {
  UserTile({super.key, required this.user});

  final UserModel user;
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (c) {
            //       return UserScreen(
            //         user: user,
            //       );
            //     },
            //   ),
            // );
          },
          //Conteúdo
          child: Card(
            margin: EdgeInsets.all(12),
            color: Colors.white.withAlpha(230),
            //elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome
                  Row(
                    children: [
                      Text('Nome ${user.name}',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),

                  // Email
                  Text(
                    user.email,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ),

        //Botão Edit Product
        Positioned(
          top: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ProductFormPage();
              }));
            },
            child: const Icon(Icons.edit, color: Colors.red),
          ),
        )
      ],
    );
  }
}
