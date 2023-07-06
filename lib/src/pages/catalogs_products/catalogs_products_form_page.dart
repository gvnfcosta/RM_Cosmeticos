import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/models/product_model.dart';
import 'package:rm/src/pages/catalogs/components/filtra_catalogo.dart';
import '../../models/catalog_products_list.dart';
import '../../models/catalog_products_model.dart';
import '../../models/product_list.dart';

class CatalogProductsFormPage extends StatefulWidget {
  const CatalogProductsFormPage(
      {super.key, required this.seller, required this.catalog});

  final String seller;
  final String catalog;

  @override
  State<CatalogProductsFormPage> createState() =>
      _CatalogProductsFormPageState();
}

bool _isLoading = false;

final _formKey = GlobalKey<FormState>();
final _formData = <String, Object>{};

String? selectedProduct;

class _CatalogProductsFormPageState extends State<CatalogProductsFormPage> {
  @override
  void initState() {
    _formData.clear();
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
    Provider.of<CatalogProductsList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _submitForm() async {
    _formData['seller'] = widget.seller;
    _formData['catalog'] = widget.catalog;

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
      _formData.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProductsList>(context);
    final ProductList productProvider = Provider.of(context);

    List<Product> products = productProvider.items.toList();

    final List<CatalogProducts> catalogProduct = catalogProvider.items_
        .where((element) => element.seller == widget.seller)
        .where((element) => element.catalog == widget.catalog)
        .toList();

    final List<ProductFiltered> items =
        filtraCatalogo(products, catalogProduct);

    List<String> productNames = [];
    for (ProductFiltered item in items) {
      productNames.add(item.name);
    }

    List<Product> productsFiltered =
        products.where((item) => !productNames.contains(item.name)).toList();

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(240),
      appBar: AppBar(
        title: Text('${widget.seller} ${widget.catalog}',
            style: const TextStyle(fontSize: 16)),
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
                                child: DropdownButtonHideUnderline(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButton2(
                                      focusColor: Colors.white.withAlpha(240),
                                      dropdownElevation: 18,
                                      hint: Text('Produto',
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor)),
                                      items: productsFiltered
                                          .map(
                                            (item) => DropdownMenuItem<String>(
                                              value: item.name,
                                              child: Text(item.name,
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                            ),
                                          )
                                          .toList(),
                                      value: _formData['productId'],
                                      isDense: true,
                                      onChanged: (value) {
                                        setState(() => _formData['productId'] =
                                            value as String);
                                        selectedProduct = value as String;
                                      },
                                      buttonHeight: 30,
                                      buttonWidth: 10,
                                      itemHeight: 30,
                                      autofocus: true,
                                    ),
                                  ),
                                ),
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
                                      _formData['price']?.toString() ?? '0.0',
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
                                      double.parse(price ?? '0.0'),
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
