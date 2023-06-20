import 'package:flutter/material.dart';
import 'package:rm/src/models/product_model.dart';
import '/src/services/utils_services.dart';

class ProductTile extends StatelessWidget {
  ProductTile({super.key, required this.products});

  final Product products;
  // final CatalogProducts productsFiltered;
  // final List<Product> products

  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    // Product productFiltered = products
    //     .firstWhere((element) => element.name == productsFiltered.productId);

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
                    products.imageUrl,
                  ),
                ),

                //Nome
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'RM ${products.code}\n${products.name}', //\n${productsFiltered.seller}\n${productsFiltered.catalog}',
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Preço
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   utilsServices.priceToCurrency(product.price),
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 10,
                    //     color: CustomColors.customSwatchColor,
                    //   ),
                    // ),
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
