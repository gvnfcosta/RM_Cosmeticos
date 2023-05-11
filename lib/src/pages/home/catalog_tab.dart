import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/category_list.dart';
import '../../models/category_model.dart';
import '../../models/product_list.dart';
import '../../models/product_model.dart';
import '../pdf/pdf_page.dart';
import 'components/product_tile.dart';

class CatalogTab extends StatefulWidget {
  CatalogTab({super.key, required this.selectedCategory});

  String selectedCategory;
  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

Future<void> _refreshProducts(BuildContext context) {
  return Provider.of<ProductList>(
    context,
    listen: false,
  ).loadProducts();
}

class _CatalogTabState extends State<CatalogTab> {
  bool _isLoading = true;
  List tipo = ['De Linha', 'Promoção', 'Queima'];
  String selectedTipo = 'De Linha';

  @override
  void initState() {
    super.initState();

    Provider.of<CategoryList>(
      context,
      listen: false,
    ).loadCategories().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsPdf = Provider.of<ProductList>(context).product;

    final products = Provider.of<ProductList>(context)
        .product
        .toList()
        .where((element) => element.show)
        .toList()
        .where((element) => element.offer == selectedTipo)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final List<Category> category = Provider.of<CategoryList>(context)
        .categorias
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    List<Product> productsFiltered =
        products.where((element) => element.category == "Kits").toList();

    double tamanhoTela = MediaQuery.of(context).size.width;
    int quantidadeItemsTela = tamanhoTela ~/ 110; // divisão por inteiro

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Row(
          children: [
            Container(
                width: 100,
                transform: Matrix4.rotationZ(-10 * pi / 150)..translate(0.0, 5),
                child: Image.asset("assets/images/LogoRM.png")),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '   Produtos $selectedTipo',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdfPage(),
                  ),
                );
              },
              icon: const Icon(Icons.picture_as_pdf)),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => List.generate(
              tipo.length,
              (i) => PopupMenuItem(
                value: tipo[i],
                height: 30,
                child: Text(tipo[i]),
              ),
            ),
            onSelected: (valor) => setState(
              () {
                setState(() {
                  selectedTipo = valor.toString();
                });
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: category.length,
                    itemBuilder: (_, index) {
                      List<Product> productsFiltered = products
                          .where((element) =>
                              element.category == category[index].nome)
                          .toList();
                      return Column(
                        children: [
                          productsFiltered.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 280,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            stops: const [0.1, 0.5, 1],
                                            colors: [
                                              Colors.pink.shade800,
                                              Colors.pink.shade100,
                                              Colors.white,
                                            ],
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              ' ${category[index].nome}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 23,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          productsFiltered.isNotEmpty
                              ? GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150,
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing: 2,
                                    childAspectRatio: 10 / 16,
                                  ),
                                  itemCount: productsFiltered.length,
                                  itemBuilder: (_, index) {
                                    return ProductTile(
                                        product: productsFiltered[index]);
                                  },
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
