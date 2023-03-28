import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/auth.dart';
import '../home/catalog_tab.dart';
import '../home/category_tab.dart';
import '../home/sub_category_tab.dart';
import '../product/product_page.dart';
import '/src/pages/profile/profile_tab.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  //Controle da tela aberta
  int currentIndex = 0;
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    bool isAdmin = auth.isAdmin;

    return Scaffold(
      body: isAdmin
          ? PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController, //indica qual a tela aberta
              children: [
                CatalogTab(selectedCategory: 'Todos'),
                const CategoryTab(),
                const SubCategoryTab(),
                const ProductPage(),
                const ProfileTab(),
              ],
            )
          : PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController, //indica qual a tela aberta
              children: [
                CatalogTab(selectedCategory: 'Todos'),
                const CategoryTab(),
                const ProfileTab(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (indice) {
          setState(() {
            currentIndex = indice;
            pageController.jumpToPage(indice); //muda a tela pelo indice
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.pink.shade600,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(100),
        items: isAdmin
            ? const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book),
                  label: 'Catálogo',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Categorias',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.interests),
                  label: 'SubCategorias',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Produtos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Perfil',
                ),
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book),
                  label: 'Catálogo',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Categorias',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Perfil',
                ),
              ],
      ),
    );
  }
}
