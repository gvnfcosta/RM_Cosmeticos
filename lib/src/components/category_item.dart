import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_list.dart';
import '../models/category_model.dart';
import '../utils/app_routes.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  const CategoryItem(this.category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.star),
        title: Text(category.nome, style: const TextStyle(fontSize: 13)),
        trailing: SizedBox(
          width: 96,
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  iconSize: 20,
                  color: Colors.purple,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.categoryForm, arguments: category);
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
                            Provider.of<CategoryList>(context, listen: false)
                                .removeCategories(category);
                            Navigator.of(ctx).pop();
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
