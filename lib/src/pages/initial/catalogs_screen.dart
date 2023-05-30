import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/user_model.dart';
import 'package:rm/src/pages/user/user_form_page.dart';
import '../../models/catalog_list.dart';
import '../../models/catalog_model.dart';
import '../../models/user_list.dart';
import '../home/components/catalog_tile.dart';

class CatalogsScreen extends StatefulWidget {
  const CatalogsScreen({super.key});

  @override
  State<CatalogsScreen> createState() => _CatalogsScreenState();
}

class _CatalogsScreenState extends State<CatalogsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<CatalogList>(
      context,
      listen: false,
    ).loadData().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogList>(context);
    final List<CatalogModel> catalogs = provider.lista.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Catálogos', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (c) => const UserFormPage()),
              // );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      // Campo Pesquisa
      body: !_isLoading
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: catalogs.length,
                      itemBuilder: (_, i) {
                        return CatalogTile(catalog: catalogs[i]);
                      },
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 10 / 11,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(),
    );
  }
}
