import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/catalog_products_list.dart';
import '../../../models/catalog_products_model.dart';
import '../../../models/product_list.dart';
import '../../../services/utils_services.dart';
import '../../../utils/app_routes.dart';

class ProductUnitTile extends StatefulWidget {
  const ProductUnitTile(
      {super.key, required this.product, required this.dataPath});

  final CatalogProducts product;
  final String dataPath;

  @override
  State<ProductUnitTile> createState() => _ProductUnitTileState();
}

bool _isLoading = false;
bool _editProduct = true;

class _ProductUnitTileState extends State<ProductUnitTile> {
  final UtilsServices utilsServices = UtilsServices();

  @override
  void initState() {
    super.initState();
    Provider.of<CatalogProductsList>(
      context,
      listen: false,
    ).loadData(widget.dataPath);
    //.then((value) => setState(() => _isLoading = false));
    // Provider.of<ProductList>(
    //   context,
    //   listen: false,
    // ).loadData();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductList>(context)
        .items
        .toList()
        .where((element) => element.name == widget.product.productId)
        .toList();
    // final catalogProduct = Provider.of<CatalogProductsList>(context)
    //     .items
    //     .toList()
    //     .where((element) => element.productId == product.first.name);

    return Stack(
      children: [
        product.isEmpty
            ? const Center()
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
                          CustomLabel('Código', product.first.code),
                          CustomLabel('Produto', product.first.name),
                          CustomLabel('Descrição', product.first.description),
                          CustomLabel(
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

        //Botão Edit Product
        _editProduct
            ? Positioned(
                top: 20,
                right: 20,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            AppRoutes.catalogProductsForm,
                            arguments: widget.product);
                      },
                      child:
                          const Icon(Icons.edit_outlined, color: Colors.orange),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                    title: const Text(
                                        'Excluir Produto do Catálogo'),
                                    content: const Text('Tem certeza?'),
                                    actions: [
                                      TextButton(
                                          child: const Text('NÃO'),
                                          onPressed: () =>
                                              Navigator.of(ctx).pop()),
                                      TextButton(
                                          child: const Text('SIM'),
                                          onPressed: () {
                                            Provider.of<CatalogProductsList>(
                                                    context,
                                                    listen: false)
                                                .removeData(widget.product,
                                                    widget.dataPath);
                                            Navigator.of(ctx).pop();
                                          })
                                    ]));
                      },
                      child:
                          const Icon(Icons.delete_outlined, color: Colors.red),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}

class CustomLabel extends StatelessWidget {
  const CustomLabel(this.label, this.description, {super.key});

  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
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
