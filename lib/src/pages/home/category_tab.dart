import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/auth.dart';
import '../../models/category_list.dart';
import '../../models/category_model.dart';
import '../../utils/app_routes.dart';
import 'components/category_tile.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  bool _isLoading = true;

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
    final provider = Provider.of<CategoryList>(context);
    Auth auth = Provider.of(context);
    String? isEmail = auth.email;
    bool isAdmin = true;

    final List<Category> categories = provider.categories.toList()
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
                Navigator.of(context).pushNamed(AppRoutes.categoryForm);
              },
              icon: isAdmin ? const Icon(Icons.add) : const SizedBox()),
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
                        childAspectRatio: 10 / 14,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (_, index) {
                        return CategoryTile(
                          category: categories[index],
                          isAdmin: isAdmin,
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
