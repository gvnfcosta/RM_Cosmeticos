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
    return Card(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Imagem
          SizedBox(height: 70, child: Image.network(item.imageUrl)),

          //Nome
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                    AppRoutes.catalogProductsEditForm,
                    arguments: item);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomLabel(
                      label: 'Código', description: item.code, fontSize: 10),
                  CustomLabel(
                    label: 'Produto',
                    description: item.name,
                    fontColor: Colors.red[900],
                  ),
                  CustomLabel(
                      label: 'Descrição',
                      description: item.description,
                      customWidth: deviceSize.width * 0.60,
                      fontSize: 10),
                  CustomLabel(
                      label: 'Preço',
                      description:
                          utilsServices.priceToCurrency(item.price).toString(),
                      fontSize: 11),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 20,
            child: TextButton(
              onPressed: () {
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
          ),
        ],
      ),
    );
  }
}
