import 'package:flutter/material.dart';
import '../../product/product_screen.dart';
import '../../product/products_form_page.dart';
import '/src/config/custom_colors.dart';
import '../../../models/product_model.dart';
import '/src/services/utils_services.dart';

class ProductTile extends StatelessWidget {
  ProductTile({super.key, required this.product});

  final Product product;
  final UtilsServices utilsServices = UtilsServices();

  final bool editProduct = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) {
                  return ProductScreen(
                    product: product,
                  );
                },
              ),
            );
          },
          //Conteúdo
          child: Card(
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Imagem
                SizedBox(
                  child: Image.network(product.imageUrl),
                ),

                //Nome
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    'RM ${product.code}\n${product.name}',
                    style: const TextStyle(fontSize: 9),
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
                        fontSize: 12,
                        color: CustomColors.customSwatchColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        //Botão Edit Product
        editProduct
            ? Positioned(
                top: 20,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ProductFormPage();
                    }));
                  },
                  child: const Icon(
                    Icons.edit,
                    color: Colors.red,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
