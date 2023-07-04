import 'package:flutter/material.dart';
import 'package:rm/src/models/category_model.dart';
import 'package:rm/src/models/product_filtered.dart';
import '../products_tab.dart';
import '/src/config/custom_colors.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.items,
  });

  final Category category;
  final List<ProductFiltered> items;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) {
                  return ProductsTab(
                    selectedCategory: category.nome,
                    items: items,
                  );
                },
              ),
            );
          },
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    child: Image.network(
                  category.imageUrl,
                  fit: BoxFit.contain,
                )),
                Text(
                  category.nome,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.customContrastColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
