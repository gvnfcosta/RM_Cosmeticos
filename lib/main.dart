import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/models/category_list.dart';
import 'src/models/product_list.dart';
import 'src/pages/auth/sign_in_screen.dart';
import 'src/pages/category/category_form_page.dart';
import 'src/pages/category/category_page.dart';
import 'src/pages/home/catalog_tab.dart';
import 'src/pages/base/base_screen.dart';
import 'src/pages/product/product_page.dart';
import 'src/pages/product/products_form_page.dart';
import 'src/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductList()),
        ChangeNotifierProvider(create: (_) => CategoryList()),
      ],
      child: MaterialApp(
        title: 'RM',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.white.withAlpha(190),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          //AppRoutes.home: (ctx) => const ProductPage(),
          AppRoutes.home: (ctx) => const SignInScreen(),
          AppRoutes.baseScreen: (ctx) => const BaseScreen(),
          AppRoutes.productPage: (ctx) => const ProductPage(),
          AppRoutes.productForm: (ctx) => const ProductFormPage(),
          AppRoutes.categoryForm: (ctx) => const CategoryFormPage(),
          AppRoutes.categoryPage: (ctx) => const CategoryPage(),
          AppRoutes.catalogTab: (ctx) => CatalogTab(selectedCategory: 'Kits'),
        },
      ),
    );
  }
}
