import 'package:flutter/material.dart';
import '../../../models/sub_category_model.dart';
import '../../../utils/app_routes.dart';
import '/src/config/custom_colors.dart';

class SubCategoryTile extends StatelessWidget {
  SubCategoryTile({super.key, required this.subCategory});

  final SubCategory subCategory;
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRoutes.subCategoryForm, arguments: subCategory);
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Text(
              subCategory.nome,
              style: TextStyle(
                color: CustomColors.customContrastColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
