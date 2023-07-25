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
    // List<UserModel> user = Provider.of<UserList>(context).user;
    // if (user.isNotEmpty) {
    //   userName = user.first.name;
    //   isAdmin = user.first.level == 0;
    // }

    UserModel? users = Provider.of<UserList>(context, listen: false).firstUser;

    String userName = users?.name ?? '';
    int userLevel = users?.level ?? 1;
    isAdmin = userLevel == 0;

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
        backgroundColor: const Color.fromARGB(255, 140, 0, 110).withAlpha(150),
        title: Stack(alignment: Alignment.center, children: [
          Image.asset('assets/images/LogoRM.png'),
          Text(
            'Catálogos ${userName == "Admin" ? "Vendedores" : userName}',
            style: const TextStyle(color: Colors.white),
          ),
        ]),
        centerTitle: true,
        elevation: 0,
      ),

      // Campo Pesquisa
      body: !_isLoading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: RefreshIndicator(
                      onRefresh: () => _refreshData(context),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 8 / 12,
                        ),
                        itemCount: catalogs.length,
                        itemBuilder: (_, i) {
                          return CatalogTile(catalog: catalogs[i]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => const CatalogFormPage())),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

Future<void> _refreshData(BuildContext context) {
  return Provider.of<CatalogList>(context, listen: false).loadData();
}
