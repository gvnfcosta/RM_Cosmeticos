import 'package:flutter/material.dart';
import 'package:rm/src/models/product_filtered.dart';
import '/src/config/custom_colors.dart';
import '/src/services/utils_services.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.products});

  final ProductFiltered products;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final UtilsServices utilsServices = UtilsServices();

  int cartItemQuantity = 1;
  final bool editProduct = false;

  final customPreco = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: CustomColors.customSwatchColor);

  @override
  Widget build(BuildContext context) {
    final productUnit = widget.products;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Conteúdo
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: productUnit.imageUrl,
                    child: InteractiveViewer(
                      child: Image.network(productUnit.imageUrl),
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(210),
                    //color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.pink.shade300,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Código
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'RM ${productUnit.code}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic),
                            ),

                            // Preço
                          ),
                          Text(
                            utilsServices.priceToCurrency(productUnit.price),
                            style: customPreco,
                          ),
                          Text(
                            ' / ${productUnit.unit}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                            ),
                          )
                        ],
                      ),

                      //Nome
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Nome: ${productUnit.name}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Descrição
                      Text(
                        widget.products.description,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: SafeArea(
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  )),
            ),
          ),
          // editProduct
          //     ? Positioned(
          //         right: 10,
          //         top: 10,
          //         child: SafeArea(
          //           child: IconButton(
          //               onPressed: () {
          //                 Navigator.of(context).pushNamed(AppRoutes.productForm,
          //                     arguments: widget.product);
          //               },
          //               icon: const Icon(
          //                 Icons.edit,
          //                 color: Colors.deepOrange,
          //               )),
          //         ),
          //       )
          //     : const SizedBox(),
        ],
      ),
    );
  }
}
