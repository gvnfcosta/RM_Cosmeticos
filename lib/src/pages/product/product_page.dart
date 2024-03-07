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
List<Product> products = [];

String selectedCategory = 'Todos os Produtos';

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false).loadData();
    // .then((value) => setState(() => _isLoading = false));
    Provider.of<CategoryList>(context, listen: false).loadCategories();
    // .then((value) => setState(() => _isLoading = false));
  }

  List<String> allCategories = ['Todos os Produtos'];
  bool _isSecret = false;
  bool byCode = false;
  int productsLenght = 0;

  @override
  Widget build(BuildContext context) {
    // List<UserModel> user = Provider.of<UserList>(context).user;
    // if (user.isNotEmpty) {
    //   isAdmin = user.first.level == 0;
    // }

    UserModel? users = Provider.of<UserList>(context, listen: false).user;

    int userLevel = users?.level ?? 1;
    isAdmin = userLevel == 0;

    final List<Product> productsByName = Provider.of<ProductList>(context)
        .items
        .where((element) => element.show == !_isSecret)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final List<Product> productsByCode = Provider.of<ProductList>(context)
        .items
        .where((element) => element.show == !_isSecret)
        .toList()
      ..sort((a, b) => a.code.compareTo(b.code));

    if (byCode) {
      products = productsByCode;
    } else {
      products = productsByName;
    }

    List<Product> productsFiltered = products
        .where((element) => element.category == selectedCategory)
        .toList();

    List<Category> categories = Provider.of<CategoryList>(context)
        .items
        .toList()
      ..sort(((a, b) => a.nome.compareTo(b.nome)));

    if (selectedCategory == "Todos os Produtos") {
      productsLenght = products.length;
    } else {
      productsLenght = productsFiltered.length;
    }

    if (allCategories.length == 1) {
      for (final value in categories) {
        allCategories.add(value.nome);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                height: 35,
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
      body:
          //  _isLoading          ? const Center(child: CircularProgressIndicator())          :
          Column(
        children: [
          Container(
            height: 40,
            color: Colors.pink[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    '$selectedCategory ($productsLenght)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.code),
                  onPressed: () => setState(
                    () {
                      byCode = !byCode;
                    },
                  ),
                ),
              ],
            ),
          ),

          // Categories

          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refreshProduct(context),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120,
                  childAspectRatio: 0.6,
                ),
                itemCount: productsLenght,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, index) =>
                    selectedCategory == "Todos os Produtos"
                        ? ProductTile(products[index])
                        : ProductTile(productsFiltered[index]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.productForm),
        child: IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.productForm),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}

Future<void> _refreshProduct(BuildContext context) =>
    Provider.of<ProductList>(context, listen: false).loadData();
