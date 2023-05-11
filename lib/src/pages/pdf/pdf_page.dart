import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import '../../config/custom_colors.dart';
import '../../models/product_list.dart';
import '../../models/product_model.dart';
import '../home/components/product_tile.dart';
import '/src/services/utils_services.dart';

class PdfPage extends StatelessWidget {
  const PdfPage({super.key});
  // const PdfPage({super.key, required this.products});

  //final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductList>(context).product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Page(products);
          },
          child: const Text('Gerar Pdf'),
        ),
      ),
    );
  }
}

Future<void> Page(List<Product> products) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) {
          return pw.Row(children: [
             Image.network(products[i].imageUrl),
                

                //Nome
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 22),
                  child: pw.Text(
                    'RM ${products[i].code}\n${products[i].name}',
                    style: pw.TextStyle(fontSize: 9),
                    textAlign: pw.TextAlign.center,
                  ),
                ),

                //Preço
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text((products[i].price.toStringAsFixed(2)),
                      style: pw.TextStyle(
                        fontWeight: pFontWeight.w500,
                        fontSize: 12,
                        color: pCustomColors.customSwatchColor,
                      ),
                    ),
                  ],
                ),
            // pw.Text(products[i].name),
            // pw.SizedBox(width: 20),
            // pw.Text(products[i].price.toString()),
          ]);
        },
      ),
      // pw.Text(products.first.name),
    ),
  );
  final file = File('example.pdf');
  await file.writeAsBytes(await pdf.save());
}
