import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import '../../../models/product_model.dart';
//import '../../../models/products.dart';

Future<Uint8List> makePdf(Product products) async {
  final pdf = Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/images/logoRM.png')).buffer.asUint8List());
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Attention to: ${products.name}"),
                    Text(products.id),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(imageLogo), // RM Logo
                )
              ],
            ),
            Container(height: 50),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    Padding(
                      child: Text(
                        'CATÁLOGO DE PRODUTOS',
                        //  style: Theme.of(context).header4,
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                  ],
                ),
                // ...products.map(
                //   (e) => TableRow(
                //     children: [
                //       Expanded(
                //         child: PaddedText(e.description),
                //         flex: 2,
                //       ),
                //       Expanded(
                //         child: PaddedText("\$${e.price}"),
                //         flex: 1,
                //       )
                //     ],
                //   ),
                // ),
                TableRow(
                  children: [
                    PaddedText('TAX', align: TextAlign.right),
                    //PaddedText(
                    // '\$${(products.totalCost() * 0.1).toStringAsFixed(2)}'),
                  ],
                ),
                TableRow(
                  children: [
                    PaddedText('TOTAL', align: TextAlign.right),
                    //  PaddedText(
                    // '\$${(products.totalCost() * 1.1).toStringAsFixed(2)}')
                  ],
                )
              ],
            ),
            Padding(
              child: Text(
                "THANK YOU FOR YOUR CUSTOM!",
                style: Theme.of(context).header2,
              ),
              padding: const EdgeInsets.all(20),
            ),
            Text(
                "Please forward the below slip to your accounts payable department."),
            Divider(
              height: 1,
              borderStyle: BorderStyle.dashed,
            ),
            Container(height: 50),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    PaddedText('Account Number'),
                    PaddedText('1234 1234')
                  ],
                ),
                TableRow(
                  children: [
                    PaddedText('Account Name'),
                    PaddedText('ADAM FAMILY TRUST')
                  ],
                ),
                TableRow(
                  children: [
                    PaddedText('Total Amount to be Paid'),
                    //  PaddedText(
                    // '\$${(products.totalCost() * 1.1).toStringAsFixed(2)}')
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                'Please ensure all cheques are payable to the ADAM FAMILY TRUST.',
                style: Theme.of(context)
                    .header3
                    .copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            )
          ],
        );
      },
    ),
  );
  return pdf.save();
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(text, textAlign: align),
    );
