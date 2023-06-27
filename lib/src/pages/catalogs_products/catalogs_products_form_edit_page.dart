import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/catalog_products_list.dart';
import '../../models/catalog_products_model.dart';
import '../../models/product_list.dart';

class CatalogProductsFormEditPage extends StatefulWidget {
  const CatalogProductsFormEditPage({super.key});

  @override
  State<CatalogProductsFormEditPage> createState() =>
      _CatalogProductsFormEditPageState();
}

bool _isLoading = false;

final _formKey = GlobalKey<FormState>();
final _formData = <String, Object>{};

String selectedProduct = '';

class _CatalogProductsFormEditPageState
    extends State<CatalogProductsFormEditPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
    Provider.of<CatalogProductsList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  String? seller;
  String? catalog;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final catalogProduct = arg as CatalogProducts;
        _formData['id'] = catalogProduct.id;
        _formData['productId'] = catalogProduct.productId;
        selectedProduct = catalogProduct.productId;
        _formData['price'] = catalogProduct.price;
        _formData['seller'] = catalogProduct.seller;
        _formData['catalog'] = catalogProduct.catalog;
        // seller = _formData['seller'].toString();
        // catalog = _formData['catalog'].toString();

        selectedProduct = _formData['productId'].toString();
      }
    }
  }

  Future<void> _submitForm() async {
    // if (_formData.isEmpty) {
    //   _formData['seller'] = widget.seller;
    //   _formData['catalog'] = widget.catalog;
    // }

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      await Provider.of<CatalogProductsList>(context, listen: false)
          .saveData(_formData);
    } catch (error) {
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: const Text('ERRO!'),
                  content: const Text('Erro na gravação dos dados'),
                  actions: [
                    TextButton(
                        child: const Text('Ok'),
                        onPressed: () => Navigator.of(context).pop())
                  ]));
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final catalogProduct =
    //     Provider.of<CatalogProductsList>(context).items.toList();

    // List<Product> products = product;
    // List<CatalogProducts> catalogProducts = catalogProduct;

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(240),
      appBar: AppBar(
        title: Text('$seller $catalog', style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(onPressed: _submitForm, icon: const Icon(Icons.check))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                ),
                                child: Text('   $selectedProduct'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                  style: const TextStyle(fontSize: 14),
                                  initialValue:
                                      _formData['price']?.toString() ?? '0',
                                  decoration: InputDecoration(
                                      labelText: 'Preço',
                                      labelStyle: const TextStyle(fontSize: 12),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  textInputAction: TextInputAction.next,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                                  onSaved: (price) => _formData['price'] =
                                      double.parse(price ?? '0'),
                                  validator: (price_) {
                                    final priceString = price_ ?? '';
                                    final price =
                                        double.tryParse(priceString) ?? -1;

                                    if (price <= 0) {
                                      return 'Informe um preço válido';
                                    }

                                    return null;
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
