// *********** CATÁLOGO TAB ************
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rm/src/models/catalog_products_list.dart';
// import 'package:rm/src/models/catalog_products_model.dart';
// import 'package:rm/src/models/category_list.dart';
// import 'package:rm/src/models/user_list.dart';
// import 'package:rm/src/models/user_model.dart';
// import '../../models/auth.dart';
// import '../../models/category_model.dart';
// import 'components/product_tile.dart';

// class CatalogTab extends StatefulWidget {
//   const CatalogTab({
//     super.key,
//     required this.selectedCategory,
//   });

//   final String selectedCategory;
//   @override
//   State<CatalogTab> createState() => _CatalogTabState();
// }

// class _CatalogTabState extends State<CatalogTab> {
//   bool _isLoading = true;
//   String selectedTipo = "Principal";

//   @override
//   void initState() {
//     super.initState();

//     Provider.of<UserList>(
//       context,
//       listen: false,
//     ).loadData().then((value) => setState(() => _isLoading = false));

//     Provider.of<CategoryList>(
//       context,
//       listen: false,
//     ).loadCategories().then((value) => setState(() => _isLoading = false));

//     Provider.of<CatalogProductsList>(
//       context,
//       listen: false,
//     ).loadData().then((value) => setState(() => _isLoading = false));
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final products = Provider.of<ProductList>(context)
//     //     .items
//     //     .toList()
//     //     .where((element) => element.show)
//     //     .toList()
//     //   ..sort((a, b) => a.name.compareTo(b.name));

//     Auth auth = Provider.of(context);
//     final List<UserModel> users = Provider.of<UserList>(context).user.toList();
//     // final List<UserModel> usuarios =
//     //     Provider.of<UserList>(context).items.toList();
//     final usuario = users.firstWhere((element) => element.email == auth.email);

//     final products = Provider.of<CatalogProductsList>(context)
//         .items
//         .where((element) => element.seller == usuario.name)
//         // .where((element) => element.catalog == selectedTipo)
//         .toList()
//       ..sort((a, b) => a.productId.compareTo(b.productId));

//     final List<Category> category = Provider.of<CategoryList>(context)
//         .categories
//         .toList()
//       ..sort((a, b) => a.nome.compareTo(b.nome));

//     return _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               backgroundColor: Colors.pinkAccent,
//               title: Row(
//                 children: [
//                   Container(
//                       width: 80,
//                       transform: Matrix4.rotationZ(-8 * pi / 150)
//                         ..translate(0.0, 6),
//                       child: Image.asset("assets/images/LogoRM.png")),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           '  Produtos $selectedTipo',
//                           style: const TextStyle(fontSize: 15),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               actions: const [
//                 // IconButton(
//                 //     onPressed: () {
//                 //       Navigator.of(context).push(
//                 //         MaterialPageRoute(
//                 //           builder: (context) => const PdfPage(),
//                 //         ),
//                 //       );
//                 //     },
//                 //     icon: const Icon(Icons.picture_as_pdf)),

//                 // PopupMenuButton(
//                 //   icon: Icon(Icons.more_vert),
//                 //   itemBuilder: (_) => List.generate(
//                 //     category.length,
//                 //     (i) => PopupMenuItem(
//                 //       value: category[i].nome,
//                 //       height: 30,
//                 //       child: Text(category[i].nome),
//                 //     ),
//                 //   ),
//                 //   onSelected: (valor) => setState(
//                 //     () {
//                 //       setState(() {
//                 //         selectedTipo = valor.toString();
//                 //       });
//                 //     },
//                 //   ),
//                 // ),
//               ],
//             ),
//             body: SafeArea(
//               child: CustomScrollView(
//                 slivers: [
//                   SliverList(
//                     delegate: SliverChildListDelegate(
//                       [
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: category.length,
//                           itemBuilder: (_, index) {
//                             List<CatalogProducts> productsFiltered = products;
//                             // .where((element) =>
//                             //     element.category == category[index].nome)
//                             // .toList();
//                             return Column(
//                               children: [
//                                 productsFiltered.isNotEmpty
//                                     ? Padding(
//                                         padding: const EdgeInsets.only(
//                                             top: 10, bottom: 8),
//                                         child: Row(
//                                           children: [
//                                             Container(
//                                               height: 30,
//                                               width: 280,
//                                               decoration: BoxDecoration(
//                                                 gradient: LinearGradient(
//                                                   stops: const [0.1, 0.5, 1],
//                                                   colors: [
//                                                     Colors.pink.shade800,
//                                                     Colors.pink.shade100,
//                                                     Colors.white,
//                                                   ],
//                                                 ),
//                                               ),
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     ' ${category[index].nome}',
//                                                     style: const TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w200,
//                                                         fontSize: 23,
//                                                         color: Colors.white),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     : const SizedBox(),
//                                 productsFiltered.isNotEmpty
//                                     ? GridView.builder(
//                                         physics:
//                                             const NeverScrollableScrollPhysics(),
//                                         shrinkWrap: true,
//                                         gridDelegate:
//                                             const SliverGridDelegateWithMaxCrossAxisExtent(
//                                           maxCrossAxisExtent: 130,
//                                           mainAxisSpacing: 1,
//                                           crossAxisSpacing: 1,
//                                           childAspectRatio: 10 / 16,
//                                         ),
//                                         itemCount: productsFiltered.length,
//                                         itemBuilder: (_, index) {
//                                           return ProductTile(
//                                               product: productsFiltered[index]);
//                                         },
//                                       )
//                                     : const SizedBox(),
//                               ],
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }
// }
