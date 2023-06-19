import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/auth.dart';
import 'package:rm/src/pages/auth/sign_up_screen.dart';
import 'package:rm/src/pages/catalogs/catalogs_products_form_page.dart';
import 'src/models/catalog_products_list.dart';
import 'src/models/catalog_list.dart';
import 'src/models/category_list.dart';
import 'src/models/product_list.dart';
import 'src/models/sub_category_list.dart';
import 'src/models/user_list.dart';
import 'src/pages/auth/auth_home_page.dart';
import 'src/pages/category/category_form_page.dart';
import 'src/pages/category/category_page.dart';
import 'src/pages/category/sub_category_form_page.dart';
import 'src/pages/category/sub_category_page.dart';
import 'src/pages/home/catalog_tab.dart';
import 'src/pages/initial/base_screen.dart';
import 'src/pages/product/product_page.dart';
import 'src/pages/product/products_form_page.dart';
import 'src/pages/user/user_form_page.dart';
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
        ChangeNotifierProvider(create: (_) => Auth()),
        // ChangeNotifierProvider(create: (_) => AdminController()),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList('', []),
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, CategoryList>(
          create: (_) => CategoryList('', []),
          update: (ctx, auth, previous) {
            return CategoryList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, CatalogProductsList>(
          create: (_) => CatalogProductsList('', []),
          update: (ctx, auth, previous) {
            return CatalogProductsList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, UserList>(
          create: (_) => UserList('', '', []),
          update: (ctx, auth, previous) {
            return UserList(
              auth.token ?? '',
              auth.email ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, CatalogList>(
          create: (_) => CatalogList('', '', []),
          update: (ctx, auth, previous) {
            return CatalogList(
              auth.token ?? '',
              auth.email ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, SubCategoryList>(
          create: (_) => SubCategoryList('', []),
          update: (ctx, auth, previous) {
            return SubCategoryList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'RM',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          textTheme: TextTheme(
            headlineMedium: TextStyle(color: Colors.pink.shade600),
            displaySmall: const TextStyle(color: Colors.white60, fontSize: 40),
          ),
          scaffoldBackgroundColor: Colors.white.withAlpha(190),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
          AppRoutes.signUpPage: (ctx) => SignUpScreen(),
          AppRoutes.baseScreen: (ctx) => const BaseScreen(),
          AppRoutes.userForm: (ctx) => const UserFormPage(),
          AppRoutes.productPage: (ctx) => const ProductPage(),
          AppRoutes.productForm: (ctx) => const ProductFormPage(),
          AppRoutes.categoryForm: (ctx) => const CategoryFormPage(),
          AppRoutes.categoryPage: (ctx) => const CategoryPage(),
          AppRoutes.catalogTab: (ctx) =>
              const CatalogTab(selectedCategory: 'Kits'),
          AppRoutes.catalogProductsForm: (ctx) =>
              const CatalogProductsFormPage(seller: '', catalog: ''),
          AppRoutes.subCategoryForm: (ctx) => const SubCategoryFormPage(),
          AppRoutes.subCategoryPage: (ctx) => const SubCategoryPage(),
        },
      ),
    );
  }
}
