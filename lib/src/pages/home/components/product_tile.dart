import 'package:flutter/material.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/pages/product/product_screen.dart';
import '/src/services/utils_services.dart';

class ProductTile extends StatelessWidget {
  ProductTile({super.key, required this.products});

  final ProductFiltered products;
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (c) => ProductScreen(products: products)),
            );
          },
          //Conteúdo
          child: Card(
            color: Colors.white,
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Imagem
                Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Image.network(products.imageUrl),
                ),

                //Código
                Text(
                  'RM ${products.code}',
                  style: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),

                //Nome
                Text(
                  products.name,
                  style: const TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),

                //Preço
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      utilsServices.priceToCurrency(products.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.pink,
                      ),
                    ),
                    Text(
                      '     ${products.pageNumber}/${products.itemNumber}',
                      style: const TextStyle(
                          fontSize: 9, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
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
