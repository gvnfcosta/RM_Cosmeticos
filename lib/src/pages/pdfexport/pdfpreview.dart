import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:rm/src/models/product_model.dart';
import 'pdf/pdfexport.dart';
//import '../../models/invoice.dart';

class PdfPreviewPage extends StatelessWidget {
  //final Invoice invoice;
  final Product products;
  const PdfPreviewPage({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Preview')),
      body: PdfPreview(build: (context) => makePdf(products)),
    );
  }
}
