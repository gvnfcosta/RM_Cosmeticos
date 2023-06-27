import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_model.dart';
import 'package:rm/src/models/catalog_products_list.dart';
import 'package:rm/src/models/catalog_products_model.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/models/product_list.dart';
import 'package:rm/src/models/product_model.dart';
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
    Provider.of<ProductList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductList>(context);
    final catalogProvider = Provider.of<CatalogProductsList>(context);

    final List<Product> products = productProvider.items
        .where((element) => element.show)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final List<CatalogProducts> catalogProduct = catalogProvider.items
        .where((element) => element.seller == widget.catalog.seller)
        .where((element) => element.catalog == widget.catalog.name)
        .toList();

    final List<ProductFiltered> items =
        filtraCatalogo(products, catalogProduct);

    return Scaffold(
      backgroundColor: Colors.white,

      // Campo Pesquisa
      body: PageView(
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
        icon: Icon(Icons.menu_book), label: 'Catálogos'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.category), label: 'Categorias'),
  ];
}

filtraCatalogo(products, catalogProduct) {
  List<ProductFiltered> items = [];

  for (var element in products) {
    String productName = element.name;
    List<CatalogProducts> catalog =
        (catalogProduct.where((t) => t.productId == productName)).toList();

    double price;

    if (catalog.isNotEmpty) {
      price = catalog.first.price;
      items.add(
        ProductFiltered(
          id: element.id,
          code: element.code,
          name: element.name,
          description: element.description,
          category: element.category,
          subCategory: element.subCategory,
          show: element.show,
          unit: element.unit,
          imageUrl: element.imageUrl,
          price: price,
        ),
      );
    }
  }
  return items;
}

// class CatalogWidget extends StatelessWidget {
//   const CatalogWidget(this.catalogFiltered, {super.key});

//   final List<CatalogProducts> catalogFiltered;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       physics: const BouncingScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: catalogFiltered.length,
//       itemBuilder: (ctx, i) {
//         return ProductUnitTile(filteredProduct: catalogFiltered[i]);
//       },
//     );
//   }
// }

// class CategoryWidget extends StatelessWidget {
//   const CategoryWidget(this.catalogFiltered, {super.key});

//   final List<CatalogProducts> catalogFiltered;

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
