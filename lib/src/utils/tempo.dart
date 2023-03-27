// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rm/src/models/product_model.dart';
// import 'package:rm/src/pages/home/components/product_tile.dart';
// import '../../models/product_list.dart';
// import '../../utils/app_routes.dart';

// class ProductsPage extends StatefulWidget {
//   const ProductsPage({Key? key}) : super(key: key);

//   @override
//   State<ProductsPage> createState() => _ProductsPageState();
// }

// class _ProductsPageState extends State<ProductsPage> {
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<ProductList>(context, listen: false)
//         .loadProducts()
//         .then((value) {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ProductList>(context);

//     final List<Product> products = provider.items.toList()
//       ..sort(((a, b) => a.name.compareTo(b.name)));

//     return !_isLoading
//         ? GestureDetector(
//             child: Scaffold(
//                 appBar: AppBar(
//                     title: const Text('Produtos',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 15)),
//                     actions: [
//                       IconButton(
//                           onPressed: () {
//                             Navigator.of(context)
//                                 .pushNamed(AppRoutes.productsForm);
//                           },
//                           icon: const Icon(Icons.add))
//                     ]),
//                 //drawer: const AppDrawer(),
//                 body: RefreshIndicator(
//                     onRefresh: () => _refreshProd(context),
//                     child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ListView.builder(
//                             itemCount: products.length,
//                             itemBuilder: (ctx, i) => Column(children: [
//                                   ProductTile(product: products[i]),
//                                   const Divider()
//                                 ]))))),
//             onTap: () {})
//         : const Center(child: CircularProgressIndicator());
//   }
// }

// Future<void> _refreshProd(BuildContext context) {
//   return Provider.of<ProductList>(context, listen: false).loadProducts();
// }
