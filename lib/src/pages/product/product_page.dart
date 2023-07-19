import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/category_list.dart';
import 'package:rm/src/models/category_model.dart';
import 'package:rm/src/models/user_list.dart';
import 'package:rm/src/models/user_model.dart';
import '../../components/product_tile.dart';
import '../../models/product_list.dart';
import '../../models/product_model.dart';
import '../../utils/app_routes.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

bool isAdmin = false;

class _ProductPageState extends State<ProductPage> {
  bool _isLoading = true;
  String selectedCategory = 'Todos os Produtos';

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

  List<String> allCategories = ["Todos os Produtos"];
  bool _isSecret = false;

  @override
  Widget build(BuildContext context) {
    List<UserModel> user = Provider.of<UserList>(context).user;
    if (user.isNotEmpty) {
      isAdmin = user.first.level == 0;
    }

    final List<Product> products = Provider.of<ProductList>(context)
        .items
        .where((element) => element.show == !_isSecret)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    List<Product> productsFiltered = products
        .where((element) => element.category == selectedCategory)
        .toList();

    final List<Category> categories = Provider.of<CategoryList>(context)
        .items
        .toList()
      ..sort(((a, b) => a.nome.compareTo(b.nome)));

    if (allCategories.length == 1) {
      for (final value in categories) {
        allCategories.add(value.nome);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      //App bar
      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/images/LogoRM.png'),
        actions: [
          IconButton(
              onPressed: () => setState(() => _isSecret = !_isSecret),
              icon: Icon(!_isSecret ? Icons.visibility : Icons.visibility_off)),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => List.generate(
              allCategories.length,
              (i) => PopupMenuItem(
                value: allCategories[i],
                height: 30,
                child: Text(allCategories[i]),
              ),
            ),
            onSelected: (valor) => setState(
              () {
                selectedCategory = valor.toString();
              },
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(AppRoutes.productForm);
          //   },
          //   icon: const Icon(Icons.add),
          // ),
        ],
      ),

      // Campo Pesquisa
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 30,
                    color: Colors.pink[50],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedCategory,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Colors.pink),
                        ),
                      ],
                    ),
                  ),
                ),

                // Categories

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 80,
                      childAspectRatio: 0.5,
                    ),
                    itemCount: selectedCategory == "Todos os Produtos"
                        ? products.length
                        : productsFiltered.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) =>
                        selectedCategory == "Todos os Produtos"
                            ? ProductTile(products[index])
                            : ProductTile(productsFiltered[index]),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.productForm);
          },
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}

Future<void> _refreshProduct(BuildContext context) {
  return Provider.of<ProductList>(context, listen: false).loadData();
}
