import 'package:flutter/material.dart';
import 'package:rm/src/models/product_filtered.dart';
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

  final customPreco = const TextStyle(
      fontSize: 25, fontWeight: FontWeight.bold, color: Colors.pink);

  @override
  Widget build(BuildContext context) {
    final productUnit = widget.products;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: productUnit.imageUrl,
                    child: InteractiveViewer(
                        child: Image.network(productUnit.imageUrl)),
                  ),
                ),
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(230),
                    //color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade600,
                          offset: const Offset(2, 2)),
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
                                  color: Colors.black54,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
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
                              fontSize: 18,
                              color: Colors.pink,
                            ),
                          )
                        ],
                      ),

                      //Nome
                      Text(
                        productUnit.name,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      //Descrição
                      Text(
                        widget.products.description,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black54),
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
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios)),
            ),
          ),
        ],
      ),
    );
  }
}
