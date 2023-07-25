import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_model.dart';
import 'package:rm/src/models/catalog_products_list.dart';
import 'package:rm/src/models/catalog_products_model.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/models/product_list.dart';
import 'package:rm/src/models/product_model.dart';
import 'package:rm/src/pages/catalogs/components/filtra_catalogo.dart';
import 'package:rm/src/pages/home/catalog_tab.dart';
import 'package:rm/src/pages/home/category_tab.dart';

class CatalogProductsPage extends StatefulWidget {
  const CatalogProductsPage(this.catalog, {super.key});

  final CatalogModel catalog;

  @override
  State<CatalogProductsPage> createState() => _CatalogProductsPageState();
}

bool _isLoading = true;

class _CatalogProductsPageState extends State<CatalogProductsPage> {
  int currentIndex = 0;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();

    Provider.of<CatalogProductsList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductList>(context);
    final catalogProvider = Provider.of<CatalogProductsList>(context);

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

      // Campo Pesquisa
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController, //indica qual a tela aberta
              children: [
                CatalogTab(items: items),
                CategoryTab(items: items),
              ],
            ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (indice) {
          setState(() {
            currentIndex = indice;
            pageController.jumpToPage(indice); //muda a tela pelo indice
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.pink.shade600,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(100),
        items: navigationItems,
      ),
    );
  }

  final List<BottomNavigationBarItem> navigationItems = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.menu_book), label: 'Produtos'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.category), label: 'Categorias'),
  ];
}
