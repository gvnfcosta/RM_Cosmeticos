import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/user_list.dart';
import 'package:rm/src/models/user_model.dart';
import '../../models/catalog_list.dart';
import '../../models/catalog_model.dart';
import 'catalog_form_page.dart';
import 'components/catalog_tile.dart';

class CatalogsPage extends StatefulWidget {
  const CatalogsPage({super.key});

  @override
  State<CatalogsPage> createState() => _CatalogsPageState();
}

class _CatalogsPageState extends State<CatalogsPage> {
  bool _isLoading = true;
  String userName = '';
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UserList>(context, listen: false).loadData();
    Provider.of<CatalogList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel> user = Provider.of<UserList>(context).user;
    if (user.isNotEmpty) {
      userName = user.first.name;
      isAdmin = user.first.level == 0;
    }

    final List<CatalogModel> allCatalogs =
        Provider.of<CatalogList>(context).items;

    List<CatalogModel> catalogs = allCatalogs.toList();

    if (userName != 'Admin') {
      catalogs =
          allCatalogs.where((element) => element.seller == userName).toList();
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Catálogos ${userName == "Admin" ? "" : userName}'),
        centerTitle: true,
        elevation: 0,
        actions: isAdmin
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => const CatalogFormPage()));
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                ),
              ]
            : null,
      ),

      // Campo Pesquisa
      body: !_isLoading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 260,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                        childAspectRatio: 10 / 12,
                      ),
                      itemCount: catalogs.length,
                      itemBuilder: (_, i) {
                        return CatalogTile(catalog: catalogs[i]);
                      },
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
