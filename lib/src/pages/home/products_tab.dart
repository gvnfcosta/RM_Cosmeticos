import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_products_list.dart';
import 'package:rm/src/models/catalog_products_model.dart';
import 'package:rm/src/models/category_list.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/pages/home/catalog_tab.dart';
import 'package:rm/src/pages/home/components/product_tile.dart';
import '../../models/product_list.dart';
import '../../models/product_model.dart';

class ProductsTab extends StatefulWidget {
  const ProductsTab(this.selectedCategory, {super.key});

  final String selectedCategory;
  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
    Provider.of<CategoryList>(context, listen: false)
        .loadCategories()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> products = Provider.of<ProductList>(context)
        .items
        .toList()
        .where((element) => element.show)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    List<Product> productsFiltered = products
        .where((element) => element.category == widget.selectedCategory)
        .toList();

    final List<CatalogProducts> catalogProduct =
        Provider.of<CatalogProductsList>(context).items
          ..sort((a, b) => a.productId.compareTo(b.productId));

    final List<ProductFiltered> items =
        filtraCatalogo(productsFiltered, catalogProduct);

    double tamanhoTela = MediaQuery.of(context).size.width;
    int quantidadeItemsTela = tamanhoTela ~/ 150; // divisão por inteiro

    return Scaffold(
      backgroundColor: Colors.white,
      //App bar
      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        centerTitle: true,
        elevation: 0,
        title: Text(widget.selectedCategory,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700)),
      ),

      // Campo Pesquisa
      body: !_isLoading
          ? Column(
              children: [
                const SizedBox(height: 12),
                Expanded(
                    child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: quantidadeItemsTela,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 8 / 11,
                  ),
                  itemCount: productsFiltered.length,
                  itemBuilder: (_, index) {
                    return ProductTile(items[index]);
                  },
                ))
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      //drawer: const AppDrawer(),
    );
  }
}
