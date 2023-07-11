import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/category_model.dart';
import '../../components/category_item.dart';
import '../../models/category_list.dart';
import '../../utils/app_routes.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryList>(context, listen: false)
        .loadCategories()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryList>(context);

    final List<Category> categories = provider.items.toList()
      ..sort(((a, b) => a.nome.compareTo(b.nome)));

    return !_isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.pink.shade200,
              title: Stack(alignment: Alignment.center, children: [
                Image.asset('assets/images/LogoRM.png'),
                const Text(
                  'Categorias',
                  style: TextStyle(fontSize: 20),
                ),
              ]),
            ),
            body: RefreshIndicator(
              onRefresh: () => _refreshCategory(context),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 85,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 4 / 4.5,
                  ),
                  itemCount: categories.length,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) => Column(
                    children: [CategoryItem(categories[i])],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.categoryForm);
              },
              child: const Icon(Icons.add),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

Future<void> _refreshCategory(BuildContext context) {
  return Provider.of<CategoryList>(context, listen: false).loadCategories();
}
