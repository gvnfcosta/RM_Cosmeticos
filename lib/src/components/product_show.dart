import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductShow extends StatelessWidget {
  const ProductShow({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: product.imageUrl,
            child: InteractiveViewer(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: SafeArea(
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            ),
          ),
        ],
      ),
    );
  }
}
