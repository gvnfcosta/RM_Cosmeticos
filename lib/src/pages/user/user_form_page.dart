import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/config/custom_colors.dart';

import '../../models/user_list.dart';
import '../../models/user_model.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  bool _isLoading = false;

  static const Map<int, String> levels = {
    0: 'Administrador',
    1: 'Vendedor',
  };

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _levelFocus = FocusNode();
  final _discountFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _data = <String, Object>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_data.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      _data['level'] = 0;
      _data['discount'] = 0.0;

      if (arg != null) {
        final user = arg as UserModel;
        _data['id'] = user.id;
        _data['name'] = user.name;
        _data['email'] = user.email;
        _data['level'] = user.level;
        _data['discount'] = user.discount;
      }
    }
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _levelFocus.dispose();
    _discountFocus.dispose();
  }

  Future<void> _submitForm() async {
    final _isValid = _formKey.currentState?.validate() ?? false;

    if (!_isValid) return;
    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<UserList>(context, listen: false).saveData(_data);
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
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      appBar: AppBar(
        title: const Text('Editar Usuários'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 200,
            child: Text(
              'Dados do\nUsuário',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 15),
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade600, offset: const Offset(0, 2)),
                ],
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // NOME
                          TextFormField(
                              maxLines: 2,
                              initialValue: _data['name']?.toString(),
                              decoration: InputDecoration(
                                labelText: 'Nome',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    gapPadding: 20),
                              ),
                              textInputAction: TextInputAction.next,
                              focusNode: _nameFocus,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocus);
                              },
                              onSaved: (name) => _data['name'] = name ?? '',
                              validator: (e) {
                                final name = e ?? '';

                                if (name.trim().isEmpty) {
                                  return 'Nome é obrigatório';
                                }

                                return null;
                              }),

                          //EMAIL
                          TextFormField(
                              maxLines: 2,
                              initialValue: _data['email']?.toString(),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    gapPadding: 20),
                              ),
                              textInputAction: TextInputAction.next,
                              focusNode: _emailFocus,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_levelFocus);
                              },
                              onSaved: (email) => _data['email'] = email ?? '',
                              validator: (e) {
                                final email = e ?? '';

                                if (email.trim().isEmpty) {
                                  return 'Email é obrigatório';
                                }

                                return null;
                              }),

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
                              const SizedBox(width: 60, child: Text('Função')),
                              DropdownButtonHideUnderline(
                                child: Expanded(
                                  child: DropdownButton2(
                                    focusNode: _levelFocus,
                                    dropdownElevation: 12,
                                    hint: Text('Selecione',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).hintColor)),
                                    items: levels
                                        .map(
                                          (value, description) {
                                            return MapEntry(
                                              description,
                                              DropdownMenuItem<String>(
                                                value: value.toString(),
                                                child: Text(description),
                                              ),
                                            );
                                          },
                                        )
                                        .values
                                        .toList(),
                                    value: _data['level'].toString(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(
                                          () {
                                            final valueString =
                                                newValue.toString() ?? '';
                                            _data['level'] =
                                                int.parse(valueString);
                                          },
                                        );
                                      }
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

                          // DISCOUNT
                          TextFormField(
                            initialValue: _data['discount']?.toString(),
                            decoration: InputDecoration(
                              labelText: 'Desconto',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  gapPadding: 20),
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: _discountFocus,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (discount) => _data['discount'] =
                                double.parse(discount ?? '0'),
                            validator: (e) {
                              final eString = e ?? '0';
                              final discount = double.tryParse(eString) ?? 0.0;
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
