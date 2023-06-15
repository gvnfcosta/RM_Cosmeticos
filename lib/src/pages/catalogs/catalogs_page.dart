import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final List<CatalogModel> catalogs = provider.items.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => const CatalogFormPage()));
            },
            icon: const Icon(
              Icons.add,
              color: Colors.orange,
            ),
          ),
        ],
      ),

      // Campo Pesquisa
      body: !_isLoading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: catalogs.length,
                      itemBuilder: (_, i) {
                        return CatalogTile(catalog: catalogs[i]);
                      },
                    ),
                  ),
                ],
              ),
            )
          : const Center(),
    );
  }
}
