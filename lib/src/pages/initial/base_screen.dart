import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/user_model.dart';
import 'package:rm/src/pages/catalogs/catalogs_page.dart';
import 'package:rm/src/pages/category/category_page.dart';
import 'package:rm/src/pages/home/components/admin_tab.dart';
import '../../models/user_list.dart';
import '../home/sub_category_tab.dart';
import '../product/product_page.dart';
import '/src/pages/profile/profile_tab.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

bool _isLoading = true;
String userName = '';
bool isAdmin = false;

class _BaseScreenState extends State<BaseScreen> {
  int currentIndex = 0;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserList>(context, listen: false)
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

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController, //indica qual a tela aberta
              children: isAdmin ? adminPageViews : userPageViews,
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
        backgroundColor: const Color.fromARGB(255, 140, 0, 110),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(100),
        items: isAdmin ? adminNavigationItens : userNavigationItens,
      ),
    );
  }

  final List<Widget> adminPageViews = [
    const CatalogsPage(),
    const CategoryPage(),
    const SubCategoryTab(),
    const ProductPage(),
    const AdminScreen(),
  ];

  final List<Widget> userPageViews = [
    const CatalogsPage(),
    const ProfileTab(),
  ];

  final List<BottomNavigationBarItem> adminNavigationItens = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.menu_book), label: 'Catálogos'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.category), label: 'Categorias'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.interests), label: 'SubCategorias'),
    const BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Produtos'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings), label: 'Painel'),
  ];

  final List<BottomNavigationBarItem> userNavigationItens = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.menu_book),
      label: 'Catálogo',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: 'Perfil',
    ),
  ];
}
