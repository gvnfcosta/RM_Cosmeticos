import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_model.dart';
import '../../../../models/catalog_products_list.dart';
import '../../../../models/catalog_products_model.dart';
import '../../../../models/category_list.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_list.dart';
import '../../../../utils/app_routes.dart';
import '/src/services/utils_services.dart';

class ProductUnitTile extends StatefulWidget {
  const ProductUnitTile(
      {super.key, required this.product, required this.catalog});

  final CatalogProducts product;
  final CatalogModel catalog;

  @override
  State<ProductUnitTile> createState() => _ProductUnitTileState();
}

bool _isLoading = true;
bool editProduct = true;

class _ProductUnitTileState extends State<ProductUnitTile> {
  final UtilsServices utilsServices = UtilsServices();

  @override
  void initState() {
    super.initState();
    Provider.of<CatalogProductsList>(
      context,
      listen: false,
    )
        .loadProducts('${widget.catalog.seller}/${widget.catalog.name}')
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseProduct = Provider.of<ProductList>(context).product.toList();
    final catalogProduct =
        Provider.of<CatalogProductsList>(context).product.toList();

    final productSelected = Provider.of<ProductList>(context)
        .product
        .toList()
        .where((element) => element.name == widget.product.productId)
        .toList()
      // .where((element) => element.offer == selectedTipo)
      // .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final List<Category> category = Provider.of<CategoryList>(context)
        .categories
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.of(context).push(
            // MaterialPageRoute(
            //   builder: (c) {
            //     return ProductScreen(product: widget.product);
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
                const SizedBox(
                    // child: Image.network(productSelected.first.name),
                    ),

                //Nome
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Text(
                        'Catalogo ${widget.product.productId}',
                        style: const TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Text(
                        'Produto ${productSelected.first.name}',
                        style: const TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Text(
                        'Catalgo R\$ ${widget.product.price}',
                        style: const TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                //Preço
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       utilsServices.priceToCurrency(product.price),
                //       style: TextStyle(
                //         fontWeight: FontWeight.w500,
                //         fontSize: 12,
                //         color: CustomColors.customSwatchColor,
                //       ),
                //     ),
                //   ],
                // ),
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
                    Navigator.of(context).pushNamed(AppRoutes.productForm,
                        arguments: widget.product);
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
