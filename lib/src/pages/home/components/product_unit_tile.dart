import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_model.dart';
import '../../../models/catalog_products_list.dart';
import '../../../models/catalog_products_model.dart';
import '../../../models/product_list.dart';
import '../../../services/utils_services.dart';
import '../../../utils/app_routes.dart';

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
    ).loadData().then((value) => setState(() => _isLoading = false));
    Provider.of<ProductList>(
      context,
      listen: false,
    ).loadData().then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    // final baseProduct = Provider.of<ProductList>(context).product.toList();
    final catalogProduct =
        Provider.of<CatalogProductsList>(context).product.toList();

    final product = Provider.of<ProductList>(context)
        .product
        .toList()
        .where((element) => element.name == widget.product.productId)
        .toList()
      // .where((element) => element.offer == selectedTipo)
      // .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    // final List<Category> category = Provider.of<CategoryList>(context)
    //     .categories
    //     .toList()
    //   ..sort((a, b) => a.nome.compareTo(b.nome));

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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Card(
                  color: Colors.grey[100],
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Imagem
                        SizedBox(
                          height: 80,
                          child: Image.network(product.first.imageUrl),
                        ),

                        //Nome
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _customText('Código', product.first.code),
                            _customText('Produto', product.first.name),
                            _customText('Descrição', product.first.description),
                            _customText(
                                'Preço',
                                utilsServices
                                    .priceToCurrency(widget.product.price)
                                    .toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),

        // Botão Edit Product
        editProduct
            ? Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        AppRoutes.catalogProductsForm,
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

  Widget _customText(String label, String description) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        Text(
          description,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}
