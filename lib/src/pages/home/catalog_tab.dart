import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_products_list.dart';
import 'package:rm/src/models/category_list.dart';
import '../../models/category_model.dart';
import '../../models/product_list.dart';
import '../../models/product_model.dart';
import 'components/product_tile.dart';
import '../../config/app_data.dart' as appData;

class CatalogTab extends StatefulWidget {
  const CatalogTab(
      {super.key, required this.selectedCategory, required this.usuario});

  final String selectedCategory;
  final String usuario;
  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab> {
  bool _isLoading = true;
  String selectedTipo = appData.ofertas[0];

  @override
  void initState() {
    super.initState();

    String dataPath = widget.usuario;

    Provider.of<CategoryList>(
      context,
      listen: false,
    ).loadCategories().then((value) => setState(() => _isLoading = false));
    Provider.of<CatalogProductsList>(
      context,
      listen: false,
    ).loadData().then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductList>(context)
        .items
        .toList()
        .where((element) => element.show)
        .toList()
      // .where((element) => element.offer == selectedTipo)
      // .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final List<Category> category = Provider.of<CategoryList>(context)
        .categories
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.pinkAccent,
              title: Row(
                children: [
                  Container(
                      width: 80,
                      transform: Matrix4.rotationZ(-8 * pi / 150)
                        ..translate(0.0, 6),
                      child: Image.asset("assets/images/LogoRM.png")),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '  Produtos $selectedTipo',
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                // IconButton(
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (context) => const PdfPage(),
                //         ),
                //       );
                //     },
                //     icon: const Icon(Icons.picture_as_pdf)),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (_) => List.generate(
                    appData.ofertas.length,
                    (i) => PopupMenuItem(
                      value: appData.ofertas[i],
                      height: 30,
                      child: Text(appData.ofertas[i]),
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
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 8),
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
                                                        fontWeight:
                                                            FontWeight.w200,
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 130,
                                          mainAxisSpacing: 1,
                                          crossAxisSpacing: 1,
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
