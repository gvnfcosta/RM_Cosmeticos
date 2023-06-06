import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/catalog_list.dart';
import '../../models/catalog_model.dart';
import '../../models/catalog_products_list.dart';
import '../../models/catalog_products_model.dart';
import '../../utils/app_routes.dart';
import '../home/components/controllers/product_unit_tile.dart';

class CatalogUnitPage extends StatefulWidget {
  const CatalogUnitPage(this.catalog, {super.key});

  final CatalogModel catalog;

  @override
  State<CatalogUnitPage> createState() => _CatalogUnitPageState();
}

class _CatalogUnitPageState extends State<CatalogUnitPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<CatalogList>(
      context,
      listen: false,
    ).loadData().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
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
  }

  @override
  Widget build(BuildContext context) {
    final List<CatalogProducts> products =
        Provider.of<CatalogProductsList>(context).items.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('CATÁLOGO ${widget.catalog.seller} ${widget.catalog.name}',
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.catalogForm);
            },
            icon: Icon(
              Icons.add,
              color: Colors.blue[300],
            ),
          ),
        ],
      ),

      // Campo Pesquisa
      body: !_isLoading
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        return ProductUnitTile(
                            product: products[i], catalog: widget.catalog);
                      },
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
