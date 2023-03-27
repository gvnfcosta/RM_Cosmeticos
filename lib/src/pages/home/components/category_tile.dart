import 'package:flutter/material.dart';
import 'package:rm/src/models/category_model.dart';
import '../../../utils/app_routes.dart';
import '../products_tab.dart';
import '/src/config/custom_colors.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category});

  final Category category;
  final bool admin = true;

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              SizedBox(height: 120, child: Image.network(category.imageUrl)),
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

        //Botão add cart
        admin
            ? Positioned(
                top: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.categoryForm,
                            arguments: category);
                      },
                      child: Ink(
                        height: 30,
                        width: 25,
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
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
