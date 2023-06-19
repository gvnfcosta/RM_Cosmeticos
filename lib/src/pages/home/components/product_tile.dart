import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/config/custom_colors.dart';
import 'package:rm/src/models/catalog_products_model.dart';
import 'package:rm/src/models/product_list.dart';
import 'package:rm/src/models/product_model.dart';
import '/src/services/utils_services.dart';

class ProductTile extends StatelessWidget {
  ProductTile({super.key, required this.product});

  final CatalogProducts product;
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductList>(context).items.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    Product productFiltered =
        products.firstWhere((element) => element.name == product.productId);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.of(context).push(
            // MaterialPageRoute(
            //   builder: (c) {
            //     return ProductScreen(product: product);
            //   },
            // ),
            // );
          },
          //Conteúdo
          child: Card(
            color: Colors.white.withAlpha(180),
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Imagem
                SizedBox(
                  child: Image.network(
                    productFiltered.imageUrl,
                  ),
                ),

                //Nome
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'RM ${productFiltered.code}\n${productFiltered.name}\n${product.seller}\n${product.catalog}',
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Preço
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      utilsServices.priceToCurrency(product.price),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: CustomColors.customSwatchColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
