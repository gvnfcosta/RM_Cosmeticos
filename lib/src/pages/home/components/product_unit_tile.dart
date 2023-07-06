import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_products_list.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/pages/catalogs/components/custom_label.dart';
import '../../../services/utils_services.dart';
import '../../../utils/app_routes.dart';

class ProductUnitTile extends StatelessWidget {
  ProductUnitTile({super.key, required this.item});

  final ProductFiltered item;

  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Stack(children: [
      Card(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            //Imagem
            SizedBox(height: 75, child: Image.network(item.imageUrl)),

            //Nome
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomLabel(label: 'Código', description: item.code),
                  const SizedBox(height: 1),
                  CustomLabel(label: 'Produto', description: item.name),
                  const SizedBox(height: 1),
                  CustomLabel(
                    label: 'Descrição',
                    description: item.description,
                    customWidth: deviceSize.width * 0.65,
                  ),
                  const SizedBox(height: 1),
                  CustomLabel(
                      label: 'Preço',
                      description:
                          utilsServices.priceToCurrency(item.price).toString()),
                ],
              ),
            ),
          ],
        ),
      ),

      //Botão Edit Product
      Positioned(
        top: 15,
        left: 8,
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.catalogProductsEditForm,
                  arguments: item);
            },
            child: const Icon(Icons.edit_outlined, color: Colors.orange),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                    title: const Text('Excluir Produto do Catálogo'),
                    content: const Text('Tem certeza?'),
                    actions: [
                      TextButton(
                          child: const Text('NÃO'),
                          onPressed: () => Navigator.of(ctx).pop()),
                      TextButton(
                          child: const Text('SIM'),
                          onPressed: () {
                            Provider.of<CatalogProductsList>(context,
                                    listen: false)
                                .removeData(item);
                            Navigator.of(ctx).pop();
                          }),
                    ]),
              );
            },
            child: const Icon(Icons.delete_outlined, color: Colors.red),
          ),
        ]),
      ),
    ]);
  }
}
