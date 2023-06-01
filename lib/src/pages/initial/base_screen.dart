import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/config/app_data.dart';
import 'package:rm/src/pages/user/users_screen.dart';
import '../../models/user_list.dart';
import '../../models/user_model.dart';
import '../home/components/admin_tab.dart';
import '../home/catalog_tab.dart';
import '../home/category_tab.dart';
import '../home/sub_category_tab.dart';
import '../product/product_page.dart';
import '/src/pages/profile/profile_tab.dart';
import '../../tempo/admin_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

bool _isLoading = true;

class _BaseScreenState extends State<BaseScreen> {
  int currentIndex = 0;
  bool isAdmin = false;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserList>(
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
    final provider = Provider.of<UserList>(context);
    final List<UserModel> users = provider.user.toList();

    if (users.isNotEmpty) isAdmin = users.first.level == Constants.levels[key, "Administrador"];

    return Scaffold(
      body: PageView(
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
        backgroundColor: Colors.pink.shade600,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(100),
        items: isAdmin ? adminNavigationItens : userNavigationItens,
      ),
    );
  }

  final List<Widget> adminPageViews = [
    const CatalogTab(selectedCategory: 'Todos'),
    const CategoryTab(),
    const SubCategoryTab(),
    const ProductPage(),
    const UsersScreen(),
  ];

  final List<Widget> userPageViews = [
    const CatalogTab(selectedCategory: 'Todos'),
    const CategoryTab(),
    const ProfileTab(),
  ];

  final List<BottomNavigationBarItem> adminNavigationItens = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.menu_book),
      label: 'Catálogo',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: 'Categorias',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.interests),
      label: 'SubCategorias',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'Produtos',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.people_outline),
      label: 'Usuários',
    ),
  ];

  final List<BottomNavigationBarItem> userNavigationItens = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.menu_book),
      label: 'Catálogo',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: 'Categorias',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: 'Perfil',
    ),
  ];
}
