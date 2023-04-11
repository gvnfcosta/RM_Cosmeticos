// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:printing/printing.dart';
// import 'package:rm/src/models/product_list.dart';
// import '../models/product_model.dart';
// import 'pdfexport/pdfpreview.dart';
// //import '../models/product.dart';

// class DetailPage extends StatelessWidget {
//   final Product product;
//   const DetailPage({Key? key, required this.product}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//                 builder: (context) => PdfPreviewPage(products: product)),
//           );
//           // rootBundle.
//         },
//         child: const Icon(Icons.picture_as_pdf),
//       ),
//       appBar: AppBar(title: Text(product.name)),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Card(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text('Customer',
//                         style: Theme.of(context).textTheme.headlineSmall),
//                   ),
//                   Expanded(
//                     child: Text(
//                       product.code,
//                       style: Theme.of(context).textTheme.headlineMedium,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Card(
//               child: Column(
//                 children: [
//                   Text('product Items',
//                       style: Theme.of(context).textTheme.titleLarge),
//                   ...product.map(
//                     (e) => ListTile(
//                       title: Text(e.description),
//                       trailing: Text(e.price.toStringAsFixed(2)),
//                     ),
//                   ),
//                   DefaultTextStyle.merge(
//                     style: Theme.of(context).textTheme.headlineMedium,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         const Text("Total"),
//                         Text(product.items[0].price.toStringAsFixed(2)),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
