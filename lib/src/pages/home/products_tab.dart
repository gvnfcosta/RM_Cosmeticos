import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/category_list.dart';
import '../../models/product_list.dart';
import '../../models/product_model.dart';
import 'components/product_tile.dart';

class ProductsTab extends StatefulWidget {
  ProductsTab(this.selectedCategory, {super.key});

  String selectedCategory;
  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

Future<void> _refreshProducts(BuildContext context) {
  return Provider.of<ProductList>(context, listen: false).loadData();
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
    final provider = Provider.of<ProductList>(context);

    final List<Product> products = provider.items.toList()
      // .where((element) => element.show)
      // .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    List<Product> productsFiltered = products
        // .where((element) =>
        //     element.category == widget.selectedCategory && element.show)
        .toList();

    final CategoryList category = Provider.of(context);

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
          ? const Column(
              children: [
                // Grid
                // const SizedBox(height: 12),
                // Expanded(
                //     child: GridView.builder(
                //   physics: const BouncingScrollPhysics(),
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: quantidadeItemsTela,
                //     mainAxisSpacing: 2,
                //     crossAxisSpacing: 2,
                //     childAspectRatio: 8 / 11,
                //   ),
                //   itemCount: widget.selectedCategory == 'Todos'
                //       ? products.length
                //       : productsFiltered.length,
                //   itemBuilder: (_, index) {
                //     return widget.selectedCategory == 'Todos'
                //         ? ProductTile(product: products[index])
                //         : ProductTile(product: productsFiltered[index]);
                //   },
                // ))
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      //drawer: const AppDrawer(),
    );
  }
}
