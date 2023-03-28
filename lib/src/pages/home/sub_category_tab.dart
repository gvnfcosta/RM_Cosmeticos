import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/sub_category_list.dart';
import '../../models/sub_category_model.dart';
import '../../utils/app_routes.dart';
import 'components/sub_category_tile.dart';

class SubCategoryTab extends StatefulWidget {
  const SubCategoryTab({super.key});

  @override
  State<SubCategoryTab> createState() => _SubCategoryTabState();
}

class _SubCategoryTabState extends State<SubCategoryTab> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<SubCategoryList>(
      context,
      listen: false,
    ).loadSubCategories().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubCategoryList>(context);

    final List<SubCategory> subCategories = provider.subCategorias.toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    double tamanhoTela = MediaQuery.of(context).size.width;
    int quantidadeItemsTela = tamanhoTela ~/ 130; // divisão por inteir

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(220),
      //App bar

      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/images/LogoRM.png'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.subCategoryForm);
              },
              icon: const Icon(Icons.add)),
        ],
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
                        childAspectRatio: 10 / 5,
                      ),
                      itemCount: subCategories.length,
                      itemBuilder: (_, index) {
                        return SubCategoryTile(
                            subCategory: subCategories[index]);
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
