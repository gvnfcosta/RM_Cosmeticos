import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/product_filtered.dart';
import 'package:rm/src/models/product_model.dart';
import 'package:rm/src/pages/catalogs/components/filtra_catalogo.dart';
import 'package:rm/src/pages/common_widgets/common_widgets.dart';
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
  final _priceFocus = FocusNode();
  final _pageNumberFocus = FocusNode();
  final _itemNumberFocus = FocusNode();

  @override
  void initState() {
    _formData.clear();
    super.initState();
    Provider.of<ProductList>(context, listen: false).loadData();
    // .then((value) => setState(() => _isLoading = false));
    Provider.of<CatalogProductsList>(context, listen: false).loadData();
    // .then((value) => setState(() => _isLoading = false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _pageNumberFocus.dispose();
    _itemNumberFocus.dispose();
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

    // List<Product> productsFiltered = products.toList()
    //   ..sort((a, b) => a.name.compareTo(b.name));

    /// Lista que exclui os itens que ja estão na list
    List<Product> productsFiltered = products
        .where((item) => !productNames.contains(item.name))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(240),
      appBar: AppBar(
        title: Text('${widget.seller} ${widget.catalog}',
            style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(onPressed: _submitForm, icon: const Icon(Icons.check))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton2(
                                focusColor: Colors.grey[200],
                                dropdownElevation: 18,
                                isExpanded: true,
                                hint: Text('Produto',
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor)),
                                items: productsFiltered
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item.name,
                                        child: Text(item.name,
                                            style:
                                                const TextStyle(fontSize: 14)),
                                      ),
                                    )
                                    .toList(),
                                value: _formData['productId'],
                                isDense: true,
                                onChanged: (value) {
                                  setState(() =>
                                      _formData['productId'] = value as String);
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextFormField(
                            style: const TextStyle(fontSize: 14),
                            initialValue:
                                _formData['price']?.toString() ?? '0.0',
                            decoration: InputDecoration(
                                labelText: 'Preço',
                                labelStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            textInputAction: TextInputAction.next,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            onSaved: (price) => _formData['price'] =
                                double.parse(price ?? '0.0'),
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_pageNumberFocus),
                            validator: (price_) {
                              final priceString = price_ ?? '';
                              final price = double.tryParse(priceString) ?? -1;

                              if (price <= 0) {
                                return 'Informe um preço válido';
                              }

                              return null;
                            }),
                      ),
                      divisor(),
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          initialValue:
                              _formData['pageNumber']?.toString() ?? '0',
                          decoration: InputDecoration(
                              labelText: 'Página',
                              labelStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          onSaved: (page) =>
                              _formData['pageNumber'] = int.parse(page ?? '0'),
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_itemNumberFocus),
                        ),
                      ),
                      divisor(),
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          initialValue:
                              _formData['itemNumber']?.toString() ?? '0',
                          decoration: InputDecoration(
                              labelText: 'Sequência',
                              labelStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          onSaved: (item) =>
                              _formData['itemNumber'] = int.parse(item ?? '0'),
                          onFieldSubmitted: (_) => _submitForm(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
