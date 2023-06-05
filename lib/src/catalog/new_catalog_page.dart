import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/catalog_model.dart';
import '../models/product_list.dart';

class NewCatalogPage extends StatefulWidget {
  const NewCatalogPage(this.catalog, {super.key});

  final CatalogModel catalog;

  @override
  State<NewCatalogPage> createState() => _NewCatalogPageState();
}

bool _isLoading = true;
final _productFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

String? selectedProduto;

class _NewCatalogPageState extends State<NewCatalogPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadProducts()
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

      if (arg != null) {
        final catalog = arg as CatalogSeller
        _formData['id'] = catalog.id;
        _formData['produto'] = catalog.produto;
      }
    }
  }

    @override
  void dispose() {
    super.dispose();
    _productFocus.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<CatalogSellerList>(context, listen: false)
          .saveSubCategories(_formData);
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
//final Product products = product.items.toList();

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(240),
      appBar: AppBar(
        title: Text(
          'Catálogo ${widget.catalog.name} ${widget.catalog.seller}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Novo Catáologo'),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: SizedBox(
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: DropdownButton2(
                          focusNode: _productFocus,
                          dropdownElevation: 12,
                          hint: Text('Produto',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).hintColor)),
                          items: product.items
                              .map((item) => DropdownMenuItem<String>(
                                  value: item.code,
                                  child: Text(item.name,
                                      style: const TextStyle(fontSize: 14))))
                              .toList(),
                          value: selectedProduto,
                          onChanged: (value) {
                            setState(
                              () {
                                 _formData['produto'] = value;
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
          ],
        ),
      ),
    );
  }
}
