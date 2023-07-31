import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/category_list.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/pages/home/components/product_tile.dart';
import '../../models/product_list.dart';

class ProductsTab extends StatefulWidget {
  const ProductsTab({
    super.key,
    required this.selectedCategory,
    required this.items,
  });

  final String selectedCategory;
  final List<ProductFiltered> items;

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
    final List<ProductFiltered> products = widget.items
        .where((element) => element.category == widget.selectedCategory)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    double tamanhoTela = MediaQuery.of(context).size.width;
    int quantidadeItemsTela = tamanhoTela ~/ 130; // divisão por inteiro

    return Scaffold(
      backgroundColor: Colors.white,
      //App bar
      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        centerTitle: true,
        elevation: 0,
        title: Row(
          children: [
            Text(widget.selectedCategory,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w200)),
          ],
        ),
      ),

      // Campo Pesquisa
      body: !_isLoading
          ? Column(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: quantidadeItemsTela,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 9 / 14,
                    ),
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      return ProductTile(products: products[index]);
                    },
                  ),
                ))
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
