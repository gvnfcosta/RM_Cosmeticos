import 'package:flutter/material.dart';
import '../../../models/sub_category_model.dart';
import '../../../utils/app_routes.dart';
import '../products_tab.dart';
import '/src/config/custom_colors.dart';

class SubCategoryTile extends StatelessWidget {
  const SubCategoryTile(
      {super.key, required this.subCategory, required this.isAdmin});

  final SubCategory subCategory;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) {
                  return ProductsTab(subCategory.nome);
                },
              ),
            );
          },
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: SizedBox(
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subCategory.nome,
                    style: TextStyle(
                      color: CustomColors.customContrastColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
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
                            arguments: subCategory);
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
            : const SizedBox(),
      ],
    );
  }
}
