import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/category_list.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/models/product_list.dart';
import '../../models/category_model.dart';
import 'components/product_tile.dart';

class CatalogTab extends StatefulWidget {
  const CatalogTab({super.key, required this.items});

  final List<ProductFiltered> items;

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

bool _isLoading = true;

class _CatalogTabState extends State<CatalogTab> {
  @override
  void initState() {
    super.initState();

    Provider.of<CategoryList>(context, listen: false).loadCategories();
    Provider.of<ProductList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final List<Category> category = Provider.of<CategoryList>(context)
        .categories
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    String catalogoName = '';
    widget.items.isNotEmpty ? catalogoName = widget.items.first.catalog : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent[100],
        title: Row(
          children: [
            Container(
                width: 80,
                transform: Matrix4.rotationZ(-8 * pi / 150)..translate(0.0, 6),
                child: Image.asset("assets/images/LogoRM.png")),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(catalogoName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                    )),
              ),
            )
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                            List<ProductFiltered> productsFiltered = widget
                                .items
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
                                    : const Center(),
                                GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150,
                                    childAspectRatio: 6 / 11,
                                  ),
                                  itemCount: productsFiltered.length,
                                  itemBuilder: (_, index) {
                                    return ProductTile(
                                        products: productsFiltered[index]);
                                  },
                                )
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
