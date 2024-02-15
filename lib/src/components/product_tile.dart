import 'package:flutter/material.dart';
import 'package:rm/src/config/app_data.dart';
import 'package:rm/src/models/product_model.dart';
import 'package:rm/src/utils/app_routes.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(AppRoutes.productForm, arguments: product),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(children: [
          //Imagem
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child:
                SizedBox(height: 120, child: Image.network(product.imageUrl)),
          ),

          //Código
          Column(
            children: [
              Text(product.code,
                  style: TextStyle(
                      fontSize: CustomSize.textSize + 8,
                      fontStyle: FontStyle.italic,
                      color: Colors.red),
                  textAlign: TextAlign.center),
            ],
          ),

          //Nome
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              product.name,
              style: TextStyle(fontSize: CustomSize.textSize + 5),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ]),
      ),
    );
  }
}
