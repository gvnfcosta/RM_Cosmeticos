import 'package:flutter/material.dart';
import 'package:rm/src/config/app_data.dart';
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
                  height: 65,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Image.network(product.imageUrl),
                ),

                //Código
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    product.code,
                    style: TextStyle(
                        fontSize: CustomSize.textSize + 6,
                        fontStyle: FontStyle.italic,
                        color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Nome
                Text(
                  product.name,
                  style: TextStyle(fontSize: CustomSize.textSize + 3),
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
