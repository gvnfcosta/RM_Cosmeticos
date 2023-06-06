import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/catalog_products_list.dart';
import '../../models/catalog_products_model.dart';
import '../../models/product_list.dart';

class CatalogFormPage extends StatefulWidget {
  const CatalogFormPage({super.key});
  //const CatalogFormPage(this.catalog, {super.key});

  //final CatalogModel catalog;

  @override
  State<CatalogFormPage> createState() => _CatalogFormPageState();
}

bool _isLoading = true;

final _formKey = GlobalKey<FormState>();
final _formData = <String, Object>{};

bool? selectedShow = false;
String? selectedProduto;

class _CatalogFormPageState extends State<CatalogFormPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CatalogProductsList>(context, listen: false)
        .loadProducts('Mauricio/Principal')
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      _formData['show'] = false;

      if (arg != null) {
        final catalog = arg as CatalogProducts;
        _formData['id'] = catalog.id;
        _formData['produtoId'] = catalog.productId;
        _formData['price'] = catalog.price;
        _formData['show'] = catalog.show;

        selectedShow = _formData['show'] as bool;
        selectedProduto = _formData['ProdutoId'].toString();
      }
    }
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<CatalogProductsList>(context, listen: false)
          .saveProduct(_formData, 'Mauricio/Principal');
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
    final ProductList product = Provider.of(context);
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(240),
      appBar: AppBar(
        title: const Text(
          'Catálogo {widget.catalog.name} {widget.catalog.seller}',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(onPressed: _submitForm, icon: const Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade600, offset: const Offset(0, 2)),
                ],
              ),
              child: !_isLoading
                  ? Form(
                      key: _formKey,
                      child: SizedBox(
                        height: deviceSize.height * 0.9,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 400,
                              child: Container(
                                width: 300,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    height: 40,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        width: 100,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: DropdownButton2(
                                            dropdownElevation: 12,
                                            hint: Text('Produto',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .hintColor)),
                                            items: product.items
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                        value: item.name,
                                                        child: Text(item.name,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14))))
                                                .toList(),
                                            value: _formData['productId'],
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  _formData['productId'] =
                                                      value as String;
                                                },
                                              );
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
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5.0, right: 5.0),
                                    child: SizedBox(
                                      height: 40,
                                      child: TextFormField(
                                          style: const TextStyle(fontSize: 14),
                                          initialValue:
                                              _formData['price']?.toString(),
                                          decoration: InputDecoration(
                                              labelText: 'Preço',
                                              labelStyle:
                                                  const TextStyle(fontSize: 12),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8))),
                                          textInputAction: TextInputAction.next,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                            decimal: true,
                                            signed: true,
                                          ),
                                          onSaved: (price) =>
                                              _formData['price'] =
                                                  double.parse(price ?? '0'),
                                          validator: (pric) {
                                            final priceString = pric ?? '';
                                            final price =
                                                double.tryParse(priceString) ??
                                                    -1;

                                            if (price <= 0) {
                                              return 'Informe um preço válido';
                                            }

                                            return null;
                                          }),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.visibility,
                                        color: Colors.indigo,
                                      ),
                                      Switch(
                                          value: selectedShow as bool,
                                          activeColor: Colors.blue,
                                          onChanged: (bool value) {
                                            setState(() {
                                              selectedShow = value;
                                              _formData['show'] = value;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
