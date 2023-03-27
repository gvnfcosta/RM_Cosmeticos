import 'package:flutter/material.dart';
import 'package:rm/src/models/product_model.dart';
import '../utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.imageUrl),
        title: Text(product.name, style: const TextStyle(fontSize: 16)),
        trailing: SizedBox(
          width: 96,
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  iconSize: 28,
                  color: Colors.purple,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.productForm, arguments: product);
                  }),
              IconButton(
                icon: const Icon(Icons.delete),
                iconSize: 25,
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
                            //  Provider.of<ProductList>(context, listen: false)
                            //      .removeCategories(categoria);
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
