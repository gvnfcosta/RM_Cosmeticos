import 'package:flutter/material.dart';
import '../../../models/sub_category_model.dart';
import '../../../utils/app_routes.dart';
import '/src/config/custom_colors.dart';

class SubCategoryTile extends StatelessWidget {
  const SubCategoryTile({super.key, required this.subCategory});

  final SubCategory subCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 200,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRoutes.subCategoryForm, arguments: subCategory);
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                subCategory.nome,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColors.customContrastColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
