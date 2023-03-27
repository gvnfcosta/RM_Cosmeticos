import 'package:flutter/material.dart';
import '../../components/product_show.dart';
import '../../utils/app_routes.dart';
import '../controllers/admin_controller.dart';
import '/src/config/custom_colors.dart';
import '../../models/product_model.dart';
import '/src/services/utils_services.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final UtilsServices utilsServices = UtilsServices();

  bool isAdmin = AdminController().isAdmin;

  int cartItemQuantity = 1;
  final bool editProduct = false;

  final customPreco = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: CustomColors.customSwatchColor);

  @override
  Widget build(BuildContext context) {
    final productUnit = widget.product;
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      body: Stack(
        children: [
          // Conteúdo
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) {
                          return ProductShow(product: widget.product);
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Hero(
                      tag: productUnit.imageUrl,
                      child: InteractiveViewer(
                        child: Image.network(
                          productUnit.imageUrl,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Código
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Código RM ${productUnit.code}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic),
                          ),

                          // Preço
                        ),
                        Text(
                          utilsServices.priceToCurrency(productUnit.price),
                          style: customPreco,
                        ),
                        Text(' / ${productUnit.unit}',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),

                    //Nome
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Nome: ${productUnit.name} - Admin: $isAdmin',
                            //maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    //Descrição
                    SingleChildScrollView(
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SingleChildScrollView(
                            child: Text(
                              'Descrição: ${widget.product.description}',
                              style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.2,
                                  color: Colors.blueGrey),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 10,
            top: 10,
            child: SafeArea(
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  )),
            ),
          ),
          editProduct
              ? Positioned(
                  right: 10,
                  top: 10,
                  child: SafeArea(
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.productForm,
                              arguments: widget.product);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.deepOrange,
                        )),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
