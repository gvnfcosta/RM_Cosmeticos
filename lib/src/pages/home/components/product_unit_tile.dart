import 'package:flutter/material.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/pages/catalogs/components/custom_label.dart';
import '../../../services/utils_services.dart';
import '../../../utils/app_routes.dart';

class ProductUnitTile extends StatelessWidget {
  ProductUnitTile({super.key, required this.items});

  final ProductFiltered items;

  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Imagem
                SizedBox(
                  height: 80,
                  child: Image.network(items.imageUrl),
                ),

                //Nome
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabel('Código', items.code),
                    CustomLabel('Produto', items.name),
                    CustomLabel('Descrição', items.description),
                    CustomLabel('Preço',
                        utilsServices.priceToCurrency(items.price).toString()),
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
                            AppRoutes.catalogProductsEditForm,
                            arguments: items);
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
                                            // Provider.of<CatalogProductsList>(
                                            //         context,
                                            //         listen: false)
                                            //     .removeData(items);
                                            // Navigator.of(ctx).pop();
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

bool _isLoading = false;
bool _editProduct = true;
