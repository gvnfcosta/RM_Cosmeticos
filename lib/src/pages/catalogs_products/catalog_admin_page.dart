import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_model.dart';
import 'package:rm/src/models/catalog_products_list.dart';
import 'package:rm/src/models/catalog_products_model.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/models/product_list.dart';
import 'package:rm/src/models/product_model.dart';
import 'package:rm/src/pages/catalogs/components/filtra_catalogo.dart';
import 'package:rm/src/pages/catalogs_products/catalogs_products_form_page.dart';
import 'package:rm/src/pages/home/components/product_unit_tile.dart';

class CatalogAdminPage extends StatefulWidget {
  const CatalogAdminPage({super.key, required this.catalog});

  final CatalogModel catalog;

  @override
  State<CatalogAdminPage> createState() => _CatalogAdminPageState();
}

bool _isLoading = true;

class _CatalogAdminPageState extends State<CatalogAdminPage> {
  @override
  void initState() {
    super.initState();

    Provider.of<CatalogProductsList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
    Provider.of<ProductList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductList>(context);
    final catalogProvider = Provider.of<CatalogProductsList>(context);

    Future.delayed(const Duration(seconds: 1));

    final List<Product> products = productProvider.items_
        .where((element) => element.show)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final List<CatalogProducts> catalogProduct = catalogProvider.items_
        .where((element) => element.seller == widget.catalog.seller)
        .where((element) => element.catalog == widget.catalog.name)
        .toList();

    final List<ProductFiltered> items =
        filtraCatalogo(products, catalogProduct);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Catálogo\n${widget.catalog.seller} ${widget.catalog.name}',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CatalogProductsFormPage(
                          seller: widget.catalog.seller,
                          catalog: widget.catalog.name,
                        )));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                return ProductUnitTile(item: items[i]);
              },
            ),
    );
  }
}
