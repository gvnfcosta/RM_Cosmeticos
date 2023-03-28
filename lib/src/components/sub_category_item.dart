import 'package:flutter/material.dart';
import '../models/sub_category_model.dart';
import '../utils/app_routes.dart';

class SubCategoryItem extends StatelessWidget {
  final SubCategory subCategory;
  const SubCategoryItem(this.subCategory, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Container(
            alignment: Alignment.center,
            child:
                Text(subCategory.nome, style: const TextStyle(fontSize: 13))),
        trailing: SizedBox(
          width: 96,
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  iconSize: 20,
                  color: Colors.purple,
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.subCategoryForm,
                        arguments: subCategory);
                  }),
              IconButton(
                icon: const Icon(Icons.delete),
                iconSize: 20,
                color: Theme.of(context).colorScheme.error,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Excluir Categoria'),
                      content: const Text('Tem certeza?'),
                      actions: [
                        TextButton(
                            child: const Text('NÃO'),
                            onPressed: () => Navigator.of(ctx).pop()),
                        TextButton(
                          child: const Text('SIM'),
                          onPressed: () {
                            // Provider.of<CategoryList>(context, listen: false)
                            //     .removeSubCategories(subCategory);
                            // Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
