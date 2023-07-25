import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/product_filtered.dart';
import '../../models/category_list.dart';
import '../../models/category_model.dart';
import '../../utils/app_routes.dart';
import 'components/category_tile.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key, required this.items});

  final List<ProductFiltered> items;

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  bool _isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryList>(context, listen: false)
        .loadCategories()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final List<Category> categories = Provider.of<CategoryList>(context)
        .categories
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    return Scaffold(
      backgroundColor: Colors.white,
      //App bar
      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        centerTitle: true,
        elevation: 0,
        title: const Text('Categorias'),
        actions: isAdmin
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.categoryForm);
                  },
                  icon: const Icon(Icons.add),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: !_isLoading
            ? Column(
                children: [
                  // Grid
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 180,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 12 / 16,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (_, index) {
                        return CategoryTile(
                          category: categories[index],
                          items: widget.items,
                        );
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
