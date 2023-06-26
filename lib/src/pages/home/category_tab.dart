import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/catalog_products_list.dart';
import 'package:rm/src/models/catalog_products_model.dart';
import 'package:rm/src/models/user_list.dart';
import 'package:rm/src/models/user_model.dart';
import '../../models/category_list.dart';
import '../../models/category_model.dart';
import '../../utils/app_routes.dart';
import 'components/category_tile.dart';

class CategoryTab extends StatefulWidget {
  CategoryTab(this.seller, this.catalog, {super.key});

  String seller;
  String catalog;

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  bool _isLoading = true;
  bool isAdmin = false;
  String userName = '';

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
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel> user = Provider.of<UserList>(context).user;

    if (user.isNotEmpty) {
      userName = user.first.name;
      isAdmin = user.first.level == 0;
    }
    final List<Category> categories = Provider.of<CategoryList>(context)
        .categories
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    final List<CatalogProducts> catalogProduct =
        Provider.of<CatalogProductsList>(context)
            .items
            .where((element) => element.seller == widget.seller)
            .where((element) => element.catalog == widget.catalog)
            .toList()
          ..sort((a, b) => a.productId.compareTo(b.productId));

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(220),
      //App bar
      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/images/LogoRM.png'),
        actions: isAdmin
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.categoryForm);
                  },
                  icon: const Icon(Icons.add),
                ),
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: !_isLoading
            ? Column(
                children: [
                  // Grid
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 5,
                        childAspectRatio: 10 / 14,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (_, index) {
                        return CategoryTile(category: categories[index]);
                      },
                    ),
                  )
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
