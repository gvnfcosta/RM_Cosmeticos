import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/category_list.dart';
import '../../models/category_model.dart';
import '../../models/product_list.dart';
import '../../models/product_model.dart';
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
  //String selectedCategory = 'Kits';
  bool _isLoading = true;

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
    final List<Product> products = Provider.of<ProductList>(context)
        .product
        .toList()
        .where((element) => element.show)
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.pink.shade200,
              pinned: true,
              expandedHeight: 130,
              flexibleSpace: FlexibleSpaceBar(
                title: 
                    Container(
                        transform: Matrix4.rotationZ(-10 * pi / 120)
                          ..translate(-40.0, 5),
                        child: 
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: 'RM',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w300)),
                      TextSpan(
                          text: 'Cosméticos',
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 18,
                              fontWeight: FontWeight.w300)),
            ],  )),
                  ),
                
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/KitMaquiagem.png",
                        )),
                  ],
                ),
              ),
            ),
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
                                        height: 32,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.pink.shade700,
                                              Colors.pink.shade500,
                                              Colors.pink.shade400,
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
                                                  fontSize: 25,
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
                                  shrinkWrap: true,
                            //      scrollDirection: Axis.horizontal,
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
