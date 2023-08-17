import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_list.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/models/product_list.dart';
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

    // Provider.of<CategoryList>(context, listen: false).loadCategories();
    Provider.of<ProductList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    // final List<Category> category = Provider.of<CategoryList>(context)
    //     .categories
    //     .toList()
    //   ..sort((a, b) => a.nome.compareTo(b.nome));

    List<ProductFiltered> items = widget.items
      ..sort(((a, b) => a.itemNumber.compareTo(b.itemNumber)))
      ..sort(((a, b) => a.pageNumber.compareTo(b.pageNumber)));

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
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
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
                          itemCount: items.length + 1,
                          itemBuilder: (_, index) {
                            List<ProductFiltered> productsFiltered = items
                                .where((element) => element.pageNumber == index)
                                .toList();

                            // List<ProductFiltered> productsFiltered = widget
                            //     .items
                            //     .where((element) =>
                            //         element.category == category[index].nome)
                            //     .toList();
                            return Column(
                              children: [
                                productsFiltered.isNotEmpty
                                    ? //const SizedBox.shrink()
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 280,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  stops: const [0.3, 0.6, 1],
                                                  colors: [
                                                    Colors.pink.shade800,
                                                    Colors.pink.shade200,
                                                    Colors.white,
                                                  ],
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '  Página $index',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const Center(),
                                RefreshIndicator(
                                  onRefresh: () => _refreshData(context),
                                  child: GridView.builder(
                                    //scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 250,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemCount: productsFiltered.length,
                                    itemBuilder: (_, index) {
                                      return ProductTile(
                                          products: productsFiltered[index]);
                                    },
                                  ),
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

Future<void> _refreshData(BuildContext context) {
  return Provider.of<CatalogList>(context, listen: false).loadData();
}
