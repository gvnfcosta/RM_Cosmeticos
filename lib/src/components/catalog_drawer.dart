import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_list.dart';

class CatalogDrawer extends StatelessWidget {
  const CatalogDrawer({Key? key}) : super(key: key);

  Future<void> _refreshCategories(BuildContext context) {
    return Provider.of<CategoryList>(context, listen: false).loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<CategoryList>(context);
    // final List<Category> categories = provider.category.toList();

    final CategoryList categories = Provider.of(context);

    return Drawer(
      child: Column(
        children: [
          // AppBar(
          //   title: const Text('Categories!'),
          //   automaticallyImplyLeading: false,
          // ),
          const Divider(),
          // ListTile(
          //     leading: const Icon(Icons.people),
          //     title: Text(categories),
          //     onTap: () {}),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: categories.itemsCount,
            itemBuilder: (cix, i) => Column(
              children: [
                Text(categories.items[i].nome),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
