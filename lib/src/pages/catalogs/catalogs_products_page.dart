import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_model.dart';
import '../../models/catalog_list.dart';
import '../../models/catalog_products_list.dart';
import '../../models/catalog_products_model.dart';
import '../home/components/product_unit_tile.dart';
import 'catalogs_products_form_page.dart';

class CatalogProductsPage extends StatefulWidget {
  const CatalogProductsPage(this.catalog, {super.key});

  final CatalogModel catalog;

  @override
  State<CatalogProductsPage> createState() => _CatalogProductsPageState();
}

class _CatalogProductsPageState extends State<CatalogProductsPage> {
  bool _isLoadingCatalog = true;
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    Provider.of<CatalogList>(
      context,
      listen: false,
    ).loadData().then((value) => setState(() => _isLoadingCatalog = false));
    Provider.of<CatalogProductsList>(context, listen: false)
        .loadData('${widget.catalog.seller}/${widget.catalog.name}')
        .then((value) => setState(() => _isLoadingProducts = false));
  }

  @override
  Widget build(BuildContext context) {
    String dataPath = '${widget.catalog.seller}/${widget.catalog.name}';
    final List<CatalogProducts> products =
        Provider.of<CatalogProductsList>(context).items.toList();

    List<CatalogProducts> catalogSellerProducts = products
        .where((element) =>
            element.seller == widget.catalog.seller &&
            element.catalog == widget.catalog.name)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('${widget.catalog.seller} ${widget.catalog.name}',
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) =>
                      CatalogProductsFormPage(catalog: widget.catalog)));
            },
            icon: Icon(
              Icons.add,
              color: Colors.orange[300],
            ),
          ),
        ],
      ),

      // Campo Pesquisa
      body: !_isLoadingCatalog
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: catalogSellerProducts.length,
                itemBuilder: (_, i) {
                  return ProductUnitTile(
                      product: catalogSellerProducts[i], dataPath: dataPath);
                },
              ),
            )
          : const Center(child: Text('Catálogo Vazio')),
    );
  }
}

Future<void> _refreshProduct(BuildContext context, CatalogModel catalog) {
  return Provider.of<CatalogProductsList>(context, listen: false)
      .loadData('${catalog.seller}/${catalog.name}');
}
