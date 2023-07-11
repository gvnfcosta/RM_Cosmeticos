import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../utils/app_routes.dart';

class CategoryItem extends StatefulWidget {
  final Category category;
  const CategoryItem(this.category, {Key? key}) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(AppRoutes.categoryForm, arguments: widget.category);
      },
      child: Card(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(children: [
            SizedBox(
              height: 55,
              width: 60,
              child: Image.network(
                widget.category.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Text(widget.category.nome, style: const TextStyle(fontSize: 10)),
          ]),
        ),
      ),
    );
  }
}
