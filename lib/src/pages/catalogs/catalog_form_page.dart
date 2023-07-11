import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/catalog_list.dart';
import '../../models/catalog_model.dart';
import '../../models/user_list.dart';
import '../../models/user_model.dart';

class CatalogFormPage extends StatefulWidget {
  const CatalogFormPage({super.key});

  @override
  State<CatalogFormPage> createState() => _CatalogFormPageState();
}

class _CatalogFormPageState extends State<CatalogFormPage> {
  final _nameFocus = FocusNode();
  final _sellerFocus = FocusNode();
  final _discountFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _data = <String, Object>{};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<CatalogList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
    Provider.of<UserList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_data.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final catalog = arg as CatalogModel;
        _data['id'] = catalog.id;
        _data['name'] = catalog.name;
        _data['seller'] = catalog.seller;
        _data['discount'] = catalog.discount;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _sellerFocus.dispose();
    _discountFocus.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;
    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<CatalogList>(context, listen: false).saveData(_data);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('ERRO!'),
          content: const Text('Erro na gravação dos dados'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserList user = Provider.of(context);
    List<UserModel> users = user.items.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('CATÁLOGOS'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.check),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                    title: const Text('Excluir Catálogo'),
                    content: const Text('Tem certeza?'),
                    actions: [
                      TextButton(
                          child: const Text('NÃO'),
                          onPressed: () => Navigator.of(ctx).pop()),
                      TextButton(
                          child: const Text('SIM'),
                          onPressed: () {
                            Provider.of<CatalogList>(context, listen: false)
                                .removeData(ModalRoute.of(context)
                                    ?.settings
                                    .arguments as CatalogModel);
                            Navigator.of(ctx).pop();
                            Navigator.of(ctx).pop();
                          }),
                    ]),
              );
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 300,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // NOME DO CATÁLOGO
                        TextFormField(
                            maxLines: 2,
                            initialValue: _data['name']?.toString(),
                            decoration: InputDecoration(
                              labelText: 'Nome Catálogo',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  gapPadding: 20),
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: _nameFocus,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_sellerFocus);
                            },
                            onSaved: (name) => _data['name'] = name ?? '',
                            validator: (e) {
                              final name = e ?? '';

                              if (name.trim().isEmpty) {
                                return 'Nome é obrigatório';
                              }

                              return null;
                            }),

                        //VENDEDOR
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                          ),
                          child: Row(children: [
                            const SizedBox(width: 70, child: Text('Vendedor:')),
                            DropdownButtonHideUnderline(
                              child: Expanded(
                                child: DropdownButton2(
                                  focusNode: _discountFocus,
                                  dropdownElevation: 12,
                                  hint: Text('Selecione',
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor)),
                                  items: users
                                      .where((element) => element.level == 1)
                                      .toList()
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item.name,
                                          child: Text(item.name,
                                              style: const TextStyle(
                                                  fontSize: 14))))
                                      .toList(),
                                  value: _data['seller'],
                                  onChanged: (value) {
                                    setState(() {
                                      _data['seller'] = value as String;
                                    });
                                  },
                                  buttonHeight: 30,
                                  buttonWidth: 10,
                                  itemHeight: 30,
                                  autofocus: true,
                                ),
                              ),
                            ),
                          ]),
                        ),

                        //DESCONTO
                        TextFormField(
                          maxLines: 2,
                          initialValue: _data['discount']?.toString() ?? '0.0',
                          decoration: InputDecoration(
                            labelText: 'Desconto',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                gapPadding: 20),
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: _discountFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_sellerFocus);
                          },
                          onSaved: (discount) => _data['discount'] =
                              double.parse(discount ?? '0.0'),
                          validator: (e) {
                            return null;
                          },
                        ),
                      ]),
                ),
        ),
      ),
    );
  }
}
