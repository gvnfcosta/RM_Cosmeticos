import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/category_model.dart';
import '../../../models/auth.dart';
import '../../../utils/app_routes.dart';
import '../products_tab.dart';
import '/src/config/custom_colors.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    bool isAdmin = auth.isAdmin;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) {
                  return ProductsTab(category.nome);
                },
              ),
            );
          },
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                SizedBox(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    category.imageUrl,
                    fit: BoxFit.contain,
                  ),
                )),
                Text(
                  category.nome,
                  style: TextStyle(
                    color: CustomColors.customContrastColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        //Botão editar
        isAdmin
            ? Positioned(
                top: 3,
                right: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(10)),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.categoryForm,
                            arguments: category);
                      },
                      child: Ink(
                        height: 30,
                        width: 28,
                        decoration: const BoxDecoration(
                          color: Colors.pinkAccent,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
