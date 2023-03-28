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
          child: Card(
            elevation: 2,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                SizedBox(height: 120, child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(category.imageUrl),
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
                    
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
