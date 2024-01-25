import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/user_list.dart';
import 'package:rm/src/models/user_model.dart';
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
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();

    Provider.of<SubCategoryList>(
      context,
      listen: false,
    ).loadSubCategories().then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    // List<UserModel> user = Provider.of<UserList>(context).user;
    // if (user.isNotEmpty) {
    //   isAdmin = user.first.level == 0;
    // }

    UserModel? users = Provider.of<UserList>(context, listen: false).user;

    String userName = users?.name ?? '';
    int userLevel = users?.level ?? 1;
    isAdmin = userLevel == 0;

    final List<SubCategory> subCategories =
        Provider.of<SubCategoryList>(context).subCategories.toList()
          ..sort((a, b) => a.nome.compareTo(b.nome));

    // double tamanhoTela = MediaQuery.of(context).size.width;
    //int quantidadeItemsTela = tamanhoTela ~/ 130; // divisão por inteir

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(220),

      //App bar
      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        centerTitle: true,
        elevation: 0,
        title: Stack(alignment: Alignment.center, children: [
          Image.asset('assets/images/LogoRM.png'),
          const Text('SubCategorias'),
        ]),
      ),
      body: !_isLoading
          ? Column(
              children: [
                // Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      childAspectRatio: 15 / 5,
                    ),
                    itemCount: subCategories.length,
                    itemBuilder: (_, index) {
                      return SubCategoryTile(subCategory: subCategories[index]);
                    },
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.subCategoryForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
