import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_data.dart';
import '../../models/auth.dart';
import '../../models/user_list.dart';
import '../../models/user_model.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  bool _isLoading = false;
  bool _novoUsuario = true;

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

      _data['level'] = 1;
      _data['email'] = '';
      _data['discount'] = '0.0';
      _data['password'] = '';

      if (arg != null) {
        final user = arg as UserModel;
        _data['id'] = user.id;
        _data['name'] = user.name;
        _data['email'] = user.email;
        _data['level'] = user.level;
        _data['discount'] = user.discount;
        _novoUsuario = false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _levelFocus.dispose();
    _discountFocus.dispose();
  }

  Future<void> _saveNewUser() async {
    Auth auth = Provider.of(context, listen: false);

    await auth.signup(
      _data['email']!.toString(),
      _data['password']!.toString(),
    );
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;
    _formKey.currentState?.save();

    setState(() => _isLoading = true);
    if (_novoUsuario) {
      _saveNewUser();
    }

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
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_novoUsuario ? 'Novo Usuário' : 'Editar Usuário'),
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
                    title: const Text('Excluir Usuário'),
                    content: const Text('Tem certeza?'),
                    actions: [
                      TextButton(
                          child: const Text('NÃO'),
                          onPressed: () => Navigator.of(ctx).pop()),
                      TextButton(
                          child: const Text('SIM'),
                          onPressed: () {
                            Provider.of<UserList>(context, listen: false)
                                .removeData(ModalRoute.of(context)
                                    ?.settings
                                    .arguments as UserModel);
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceSize.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Form(
                        key: _formKey,
                        child: SizedBox(
                          height: 330,
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
                                  onSaved: (email) =>
                                      _data['email'] = email ?? '',
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
                                  const SizedBox(
                                      width: 60, child: Text('Função')),
                                  DropdownButtonHideUnderline(
                                    child: Expanded(
                                      child: DropdownButton2(
                                        focusNode: _levelFocus,
                                        dropdownElevation: 12,
                                        hint: Text('Selecione',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .hintColor)),
                                        items: Constants.levels
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
                                initialValue:
                                    _data['discount']?.toString() ?? '0.0',
                                decoration: InputDecoration(
                                  labelText: 'Desconto',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      gapPadding: 20),
                                ),
                                textInputAction: TextInputAction.next,
                                focusNode: _discountFocus,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: true,
                                ),
                                onFieldSubmitted: (_) => _submitForm(),
                                onSaved: (discount) => _data['discount'] =
                                    double.parse(discount ?? '0.0'),
                                validator: (e) {
                                  final eString = e ?? '0.0';
                                  // final discount = double.tryParse(eString) ?? 0.0;
                                  return null;
                                },
                              ),

                              //SENHA
                              // if (_novoUsuario)
                              //   TextFormField(
                              //     initialValue: _data['password']?.toString(),
                              //     decoration: InputDecoration(
                              //       labelText: 'Senha',
                              //       border: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(8),
                              //           gapPadding: 20),
                              //     ),
                              //     textInputAction: TextInputAction.next,
                              //     focusNode: _passwordFocus,
                              //     onFieldSubmitted: (_) {
                              //       FocusScope.of(context)
                              //           .requestFocus(_levelFocus);
                              //     },
                              //     onSaved: (password) =>
                              //         _data['password'] = password ?? '',
                              //     validator: (e) {
                              //       final password = e ?? '';

                              //       if (password.length < 6) {
                              //         return 'Senha precisa ter no mínimo 6 caracteres';
                              //       }

                              //       return null;
                              //     },
                              //   ),

                              // if (_novoUsuario)
                              //   TextFormField(
                              //     decoration: InputDecoration(
                              //       labelText: 'Confirmar Senha',
                              //       border: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(8),
                              //           gapPadding: 20),
                              //     ),
                              //     keyboardType: TextInputType.emailAddress,
                              //     //  obscureText: true,
                              //     validator: (password_) {
                              //       final password = password_ ?? '';
                              //       // if (password != _passwordController.text) {
                              //       //   return 'Senhas informadas não conferem.';
                              //       // }
                              //       return null;
                              //     },
                              // ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
