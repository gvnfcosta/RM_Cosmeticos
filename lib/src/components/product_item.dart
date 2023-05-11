import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/product_model.dart';
import '../models/product_list.dart';
import '../utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.imageUrl),
        title: Text('RM ${product.code}', style: const TextStyle(fontSize: 12)),
        subtitle: Text(product.name, style: const TextStyle(fontSize: 12)),
        trailing: SizedBox(
          width: 86,
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
                            Provider.of<ProductList>(context, listen: false)
                                .removeProduct(product);
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
