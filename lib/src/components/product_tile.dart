import 'package:flutter/material.dart';
import 'package:rm/src/models/product_model.dart';
import 'package:rm/src/utils/app_routes.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.productForm, arguments: product);
          },
          child: Card(
            color: Colors.white,
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Imagem
                Container(
                  height: 70,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Image.network(product.imageUrl),
                ),

                //Código
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'RM ${product.code}',
                    style: const TextStyle(
                        fontSize: 8,
                        fontStyle: FontStyle.italic,
                        color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Nome
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 8),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
