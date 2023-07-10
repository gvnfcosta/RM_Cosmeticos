import 'package:flutter/material.dart';
import 'package:rm/src/models/product_model.dart';
import '../utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withAlpha(245),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRoutes.productForm, arguments: product);
        },
        child: Column(
          children: [
            SizedBox(height: 60, child: Image.network(product.imageUrl)),
            Text('RM ${product.code}', style: const TextStyle(fontSize: 12)),
            Text(product.name, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
