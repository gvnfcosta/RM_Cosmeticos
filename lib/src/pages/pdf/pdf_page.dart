import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/config/app_data.dart';
import '../../models/category_list.dart';
import '../../models/category_model.dart';
import '../../models/product_list.dart';
import '../../models/product_model.dart';

class PdfPage extends StatelessWidget {
  const PdfPage({super.key});
  // const PdfPage({super.key, required this.products});
  //final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductList>(context).product;

    final List<Category> categories = Provider.of<CategoryList>(context)
        .categorias
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => page(products, categories),
          child: const Text('Gerar Pdf'),
        ),
      ),
    );
  }
}

Future<void> page(List<Product> products, List<Category> categories) async {
  final ttf = await fontFromAssetBundle('assets/Open-Sans.ttf');
  final pdf = pw.Document();
  //final image = await networkImage(products[i].imageUrl);
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.ListView.builder(
        itemCount: categories.length,
        itemBuilder: (_, index) {
          List<Product> productsFiltered = products
              .where((element) => element.category == categories[index].nome)
              .toList();
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
                  child: pw.Container(
                    alignment: pw.Alignment.centerLeft,
                    height: 20,
                    width: 250,
                    decoration: const pw.BoxDecoration(
                      gradient: pw.LinearGradient(
                        stops: [0.1, 1, 1],
                        colors: [
                          PdfColor.fromInt(0xAD1457),
                          PdfColor.fromInt(0xF8BBD0),
                          PdfColor.fromInt(0xFFFFFF),
                        ],
                      ),
                    ),
                    child: pw.Text(
                      categories[index].nome,
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor.fromInt(0xFFFFFF),
                      ),
                    ),
                  ),
                ),
                pw.Row(children: [
                  pw.ListView.builder(
                      direction: pw.Axis.horizontal,
                      itemCount: productsFiltered.length,
                      itemBuilder: (_, i) {
                        return pw.Column(children: [
                          // //Imagem
                          // pw.Padding(
                          //   padding:
                          //       const pw.EdgeInsets.symmetric(horizontal: 22),
                          //   child: pw.Image(productsFiltered[i].imageUrl
                          //       as pw.ImageProvider),
                          // ),

                          // Código
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 22),
                            child: pw.Text(
                              'RM ${productsFiltered[i].code}',
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),

                          //Nome
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 22),
                            child: pw.Text(
                              productsFiltered[i].name,
                              style: pw.TextStyle(font: ttf, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          //Preço
                          pw.Text(
                            ('R\$ ${productsFiltered[i].price.toStringAsFixed(2)}'),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: ttf,
                              fontSize: 12,
                              color: const PdfColor.fromInt(0xBB1111),
                            ),
                          ),
                        ]);
                      }),
                ]),
              ]);
        },
      ),
    ),
  );
  final file = File('example.pdf');
  await file.writeAsBytes(await pdf.save());
  // PdfPreview(
  //   build: (format) => file.save(),
  // );
}
