import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/sub_category_item.dart';
import '../../models/category_list.dart';
import '../../models/sub_category_list.dart';
import '../../models/sub_category_model.dart';
import '../../utils/app_routes.dart';

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage({Key? key}) : super(key: key);

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryList>(context, listen: false)
        .loadCategories()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubCategoryList>(context);

    final List<SubCategory> subCategories = provider.items.toList()
      ..sort(((a, b) => a.nome.compareTo(b.nome)));

    return !_isLoading
        ? GestureDetector(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  title: const Text('Subcategorias',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15)),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.subCategoryForm);
                        },
                        icon: const Icon(Icons.add)),
                  ]),
              body: RefreshIndicator(
                onRefresh: () => _refreshCategory(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: subCategories.length,
                    itemBuilder: (ctx, i) => Column(
                      children: [SubCategoryItem(subCategories[i])],
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {})
        : const Center(child: CircularProgressIndicator());
  }
}

Future<void> _refreshCategory(BuildContext context) {
  return Provider.of<CategoryList>(context, listen: false).loadCategories();
}
