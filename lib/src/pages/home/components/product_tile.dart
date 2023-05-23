import 'package:flutter/material.dart';
import '../../../utils/app_routes.dart';
import '../../product/product_screen.dart';
import '/src/config/custom_colors.dart';
import '../../../models/product_model.dart';
import '/src/services/utils_services.dart';

class ProductTile extends StatelessWidget {
  ProductTile({super.key, required this.product});

  final Product product;
  final UtilsServices utilsServices = UtilsServices();

  final bool editProduct = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) {
                  return ProductScreen(product: product);
                },
              ),
            );
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
                  child: Image.network(product.imageUrl),
                ),

                //Nome
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    'RM ${product.code}\n${product.name}',
                    style: const TextStyle(fontSize: 11),
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
                    Navigator.of(context)
                        .pushNamed(AppRoutes.productForm, arguments: product);
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
