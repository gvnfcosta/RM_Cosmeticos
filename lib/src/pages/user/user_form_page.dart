import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/config/custom_colors.dart';

import '../../models/auth.dart';
import '../../models/user_list.dart';
import '../../models/user_model.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

// final FirebaseAuth auth = FirebaseAuth.instance;

//         final String userID = auth.tenantId.
//     //final uid = user.uid;
//     // here you write the codes to input the data into firestore

class _UserFormPageState extends State<UserFormPage> {
  bool _isLoading = false;
  bool _novoUsuario = true;

  static const Map<int, String> levels = {
    0: 'Administrador',
    1: 'Vendedor',
    2: 'Cliente',
  };

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _levelFocus = FocusNode();
  final _discountFocus = FocusNode();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _data = <String, Object>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_data.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      _data['level'] = 0;
      _data['email'] = '';
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
    final _isValid = _formKey.currentState?.validate() ?? false;

    if (!_isValid) return;
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
      backgroundColor: CustomColors.customSwatchColor,
      appBar: AppBar(
        title: Text(_novoUsuario ? 'Novo Usuário' : 'Editar Usuário'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height * 0.8,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 100,
                child: Text(
                  'Dados do Usuário',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.white30, offset: Offset(5, 5)),
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
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: true,
                                ),
                                onFieldSubmitted: (_) => _submitForm(),
                                onSaved: (discount) => _data['discount'] =
                                    double.parse(discount ?? '0'),
                                validator: (e) {
                                  final eString = e ?? '0';
                                  // final discount = double.tryParse(eString) ?? 0.0;
                                  return null;
                                },
                              ),

                              //SENHA
                              if (_novoUsuario)
                                TextFormField(
                                  initialValue: _data['password']?.toString(),
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        gapPadding: 20),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  focusNode: _passwordFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_levelFocus);
                                  },
                                  onSaved: (password) =>
                                      _data['password'] = password ?? '',
                                  validator: (e) {
                                    final password = e ?? '';

                                    if (password.length < 6) {
                                      return 'Senha precisa ter no mínimo 6 caracteres';
                                    }

                                    return null;
                                  },
                                ),

                              if (_novoUsuario)
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Confirmar Senha',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        gapPadding: 20),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  //  obscureText: true,
                                  validator: (password_) {
                                    final password = password_ ?? '';
                                    // if (password != _passwordController.text) {
                                    //   return 'Senhas informadas não conferem.';
                                    // }
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
        ),
      ),
    );
  }
}
