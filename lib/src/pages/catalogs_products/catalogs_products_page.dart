import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_model.dart';
import 'package:rm/src/pages/home/catalog_tab.dart';
import 'package:rm/src/pages/home/category_tab.dart';
import '../../models/catalog_list.dart';
import '../../models/catalog_products_list.dart';
import '../../models/catalog_products_model.dart';
import '../home/components/product_unit_tile.dart';

class CatalogProductsPage extends StatefulWidget {
  const CatalogProductsPage(this.catalog, {super.key});

  final CatalogModel catalog;

  @override
  State<CatalogProductsPage> createState() => _CatalogProductsPageState();
}

class _CatalogProductsPageState extends State<CatalogProductsPage> {
  bool _isLoading = true;
  int currentIndex = 0;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    Provider.of<CatalogList>(
      context,
      listen: false,
    ).loadData().then((value) => setState(() {}));
    Provider.of<CatalogProductsList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    String seller = widget.catalog.seller;
    String catalog = widget.catalog.name;
    final List<CatalogProducts> products =
        Provider.of<CatalogProductsList>(context).items.toList();

    final List<CatalogProducts> catalogFiltered = products
        .where((element) =>
            element.seller == widget.catalog.seller &&
            element.catalog == widget.catalog.name)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,

      // Campo Pesquisa
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController, //indica qual a tela aberta
        children: [
          CatalogTab(seller, catalog),
          CategoryTab(seller, catalog),
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
        icon: Icon(Icons.menu_book), label: 'Catálogos'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.category), label: 'Categorias'),
  ];
}

class CatalogWidget extends StatelessWidget {
  const CatalogWidget(this.catalogFiltered, {super.key});

  final List<CatalogProducts> catalogFiltered;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: catalogFiltered.length,
      itemBuilder: (ctx, i) {
        return ProductUnitTile(filteredProduct: catalogFiltered[i]);
      },
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(this.catalogFiltered, {super.key});

  final List<CatalogProducts> catalogFiltered;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
