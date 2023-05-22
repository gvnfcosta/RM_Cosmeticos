import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
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
          onPressed: () => PdfPreview(
            build: (format) => _generatePdf(format),
          ),
          child: const Text('Gerar Pdf'),
        ),
      ),
    );
  }
}

Future<Uint8List> _generatePdf(PdfPageFormat format) async {
  final pdf = pw.Document();

  final img = await networkImage(
      'https://upload.wikimedia.org/wikipedia/commons/5/57/Cumulus_Clouds_over_Yellow_Prairie2.jpg');

  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Center(
          child: pw.ClipRRect(
            horizontalRadius: 10,
            verticalRadius: 10,
            child: pw.Image(img),
          ),
        );
      },
    ),
  );
  final file = File('example.pdf');
  await file.writeAsBytes(await pdf.save());
  return pdf.save();
}

MemoryImage? _logo;
MemoryImage? _image;

Future<void> page(List<Product> products, List<Category> categories) async {
  // final String imagem = pw.Image(productsFiltered[i].imageUrl)
//  final ttf = await fontFromAssetBundle('assets/Open-Sans.ttf');
  //final logo = await imageFromAssetBundle('assets/profile.jpg');

  //_logo = await rootBundle.loadString('assets/images/logo.svg');
  PdfDocument document = PdfDocument();
  //final page = document.pages.add();

  final _logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logoRM.png')).buffer.asUint8List());
  //final image = pw.MemoryImage((await rootBundle.load(products[i].imageUrl)).buffer.asUint8List());

  final ttf = await PdfGoogleFonts.robotoRegular();
  final fontRoboto = await PdfGoogleFonts.robotoRegular();
  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
        //header: _buildHeader,
        //footer: _buildFooter,
        build: (pw.Context context) {
      return [
        //  _contentHeader(context),
        pw.SizedBox(height: 20),
        pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            // pw.Container(
            //   alignment: pw.Alignment.topLeft,
            //   padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
            //   height: 72,
            //   // child: pw.Text("TESTE"),

            //   child: pw.Image(_logo!),
            // ),
            pw.ListView.builder(
              itemCount: categories.length,
              itemBuilder: (_, index) {
                List<Product> productsFiltered = products
                    .where(
                        (element) => element.category == categories[index].nome)
                    .toList();
                return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 5),
                        child: pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          padding:
                              const pw.EdgeInsets.only(left: 10, bottom: 1),
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
                              fontSize: 16,
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
                                //Imagem
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 22),
                                  child: pw.Container(
                                    alignment: pw.Alignment.center,
                                    color: PdfColors.amber100,
                                    height: 30,
                                    width: 60,
                                    // child: pw.Text('Foto',
                                    //     style: pw.TextStyle(
                                    //         font: ttf, fontSize: 18),
                                  ),
                                ),

                                // Código
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 22),
                                  child: pw.Text(
                                    'RM ${productsFiltered[i].code}',
                                    style: pw.TextStyle(font: ttf, fontSize: 8),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),

                                //Nome
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 22),
                                  child: pw.Text(
                                    productsFiltered[i].name,
                                    style:
                                        pw.TextStyle(font: ttf, fontSize: 10),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),

                                //Preço
                                pw.Text(
                                  ('R\$ ${productsFiltered[i].price.toStringAsFixed(2)}'),
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      font: fontRoboto,
                                      //font: ttf,
                                      fontSize: 12,
                                      color: PdfColors.pink600),
                                ),
                              ]);
                            }),
                      ]),
                    ]);
              },
            ),
          ],
        ),
      ];
    }),
  );
  final file = File('example.pdf');
  await file.writeAsBytes(await pdf.save());
  // PdfPreview(
  //   build: (format) => file.save(),
  // );
}



// Future<pw.ImageProvider> _readImageData(int i) async {
// //  final data = await rootBundle.load(products[i].imageUrl);
//   //return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//   final netImage = await networkImage('https://www.nfet.net/nfet.jpg');
//   return netImage;
// }

// pw.Widget _contentHeader(pw.Context context) {
//   return pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
//     pw.Expanded(
//       child: pw.Container(
//         margin: const pw.EdgeInsets.symmetric(horizontal: 20),
//         height: 20,
//         child: pw.FittedBox(
//           child: pw.Text("TESTE"),
//           //child: pw.Image(_logo!),
//         ),
//       ),
//     )
//   ]);
// }

// pw.Widget _contentFooter(pw.Context context) {
//   return pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
//     pw.Expanded(
//       child: pw.Container(
//         margin: const pw.EdgeInsets.symmetric(horizontal: 20),
//         height: 70,
//         child: pw.FittedBox(
//           child: pw.Text(
//             'FOOTER' ,
//             style: pw.TextStyle(
//               color: PdfColors.blue,
//               fontStyle: pw.FontStyle.italic,
//             ),
//           ),
//         ),
//       ),
//     )
//   ]);
// }

// pw.Widget _catalogBody(pw.Context context) {
//   return pw.Column(
//     mainAxisSize: pw.MainAxisSize.min,
//     children: [
//       pw.Container(
//         alignment: pw.Alignment.topRight,
//         padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
//         height: 72,
//         child: pw.Image(context.logo),
//       ),
//       pw.ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (_, index) {
//           List<Product> productsFiltered = products
//               .where((element) => element.category == categories[index].nome)
//               .toList();
//           return pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.only(top: 5),
//                   child: pw.Container(
//                     alignment: pw.Alignment.centerLeft,
//                     padding: const pw.EdgeInsets.only(left: 10, bottom: 1),
//                     height: 20,
//                     width: 250,
//                     decoration: const pw.BoxDecoration(
//                       gradient: pw.LinearGradient(
//                         stops: [0.1, 1, 1],
//                         colors: [
//                           PdfColor.fromInt(0xAD1457),
//                           PdfColor.fromInt(0xF8BBD0),
//                           PdfColor.fromInt(0xFFFFFF),
//                         ],
//                       ),
//                     ),
//                     child: pw.Text(
//                       categories[index].nome,
//                       style: pw.TextStyle(
//                         font: ttf,
//                         fontSize: 16,
//                         fontWeight: pw.FontWeight.bold,
//                         color: const PdfColor.fromInt(0xFFFFFF),
//                       ),
//                     ),
//                   ),
//                 ),
//                 pw.Row(children: [
//                   pw.ListView.builder(
//                       direction: pw.Axis.horizontal,
//                       itemCount: productsFiltered.length,
//                       itemBuilder: (_, i) {
//                         return pw.Column(children: [
//                           //Imagem
//                           pw.Padding(
//                             padding:
//                                 const pw.EdgeInsets.symmetric(horizontal: 22),
//                             child: pw.Text('Foto',
//                                 style: pw.TextStyle(font: ttf, fontSize: 18)),
//                             // child: pw.Image(productsFiltered[i].imageUrl
//                             //     as pw.ImageProvider),
//                           ),

//                           // Código
//                           pw.Padding(
//                             padding:
//                                 const pw.EdgeInsets.symmetric(horizontal: 22),
//                             child: pw.Text(
//                               'RM ${productsFiltered[i].code}',
//                               style: pw.TextStyle(font: ttf, fontSize: 8),
//                               textAlign: pw.TextAlign.center,
//                             ),
//                           ),

//                           //Nome
//                           pw.Padding(
//                             padding:
//                                 const pw.EdgeInsets.symmetric(horizontal: 22),
//                             child: pw.Text(
//                               productsFiltered[i].name,
//                               style: pw.TextStyle(font: ttf, fontSize: 10),
//                               textAlign: pw.TextAlign.center,
//                             ),
//                           ),
//                           //Preço
//                           pw.Text(
//                             ('R\$ ${productsFiltered[i].price.toStringAsFixed(2)}'),
//                             style: pw.TextStyle(
//                                 fontWeight: pw.FontWeight.bold,
//                                 font: fontRoboto,
//                                 //font: ttf,
//                                 fontSize: 12,
//                                 color: PdfColors.pink600),
//                           ),
//                         ]);
//                       }),
//                 ]),
//               ]);
//         },
//       ),
//     ],
//   );
// }

// pw.Widget _buildHeader(pw.Context context) {
//   return pw.Column(
//     children: [
//       pw.Row(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Expanded(
//             child: pw.Column(
//               children: [
//                 // pw.Container(
//                 //   height: 50,
//                 //   padding: const pw.EdgeInsets.only(left: 20),
//                 //   alignment: pw.Alignment.centerLeft,
//                 //   child: pw.Text(
//                 //     'RMCosméticos',
//                 //     style: pw.TextStyle(
//                 //       color: PdfColors.pink,
//                 //       fontWeight: pw.FontWeight.bold,
//                 //       fontSize: 20,
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//           // pw.Column(
//           //   mainAxisSize: pw.MainAxisSize.min,
//           //   children: [
//           //     pw.Container(
//           //       alignment: pw.Alignment.topRight,
//           //       padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
//           //       height: 72,
//           //       child: pw.Image(logo as pw.ImageProvider),
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//       if (context.pageNumber > 1) pw.SizedBox(height: 20)
//     ],
//   );
// }

// pw.Widget _buildFooter(pw.Context context) {
//   return pw.Row(
//     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//     crossAxisAlignment: pw.CrossAxisAlignment.end,
//     children: [
//       pw.Text(
//         'Page ${context.pageNumber}/${context.pagesCount}',
//         style: const pw.TextStyle(
//           fontSize: 12,
//           color: PdfColors.black,
//         ),
//       ),
//     ],
//   );
// }
