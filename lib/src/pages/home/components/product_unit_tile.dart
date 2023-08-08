import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_products_list.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/pages/catalogs/components/custom_label.dart';
import '../../../services/utils_services.dart';
import '../../../utils/app_routes.dart';

class ProductUnitTile extends StatefulWidget {
  const ProductUnitTile({super.key, required this.item});

  final ProductFiltered item;

  @override
  State<ProductUnitTile> createState() => _ProductUnitTileState();
}

class _ProductUnitTileState extends State<ProductUnitTile> {
  final UtilsServices utilsServices = UtilsServices();
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Imagem
          SizedBox(
              height: 70,
              width: 80,
              child: Image.network(widget.item.imageUrl)),
          const SizedBox(width: 10),
          //Nome
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                    AppRoutes.catalogProductsEditForm,
                    arguments: widget.item);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomLabel(
                      label: 'Código',
                      description: widget.item.code,
                      fontSize: 10),
                  CustomLabel(
                    label: 'Produto',
                    description: widget.item.name,
                    fontColor: Colors.red[900],
                  ),
                  CustomLabel(
                      label: 'Descrição',
                      description: widget.item.description,
                      customWidth: deviceSize.width * 0.60,
                      fontSize: 10),
                  CustomLabel(
                    label: 'Preço',
                    description: utilsServices
                        .priceToCurrency(widget.item.price)
                        .toString(),
                    fontSize: 11,
                    fontColor: Colors.red,
                  ),
                  CustomLabel(
                      label: 'Descrição',
                      description:
                          '${widget.item.pageNumber} - ${widget.item.itemNumber}',
                      customWidth: deviceSize.width * 0.60,
                      fontSize: 10),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 35,
            width: 35,
            child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                        title: const Text('EXCLUIR PRODUTO DESTE CATÁLOGO'),
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
                                    .removeData(widget.item);
                                Navigator.of(ctx).pop();
                              }),
                        ]),
                  );
                },
                child: isHover
                    ? const Icon(Icons.delete, color: Colors.red)
                    : const Icon(Icons.delete_outline, color: Colors.red),
                onHover: (val) {
                  setState(() {
                    isHover = val;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
