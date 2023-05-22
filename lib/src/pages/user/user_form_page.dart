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

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _discountFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _data = <String, Object>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_data.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      _data['discount'] = 0.0;

      if (arg != null) {
        final user = arg as UserModel;
        _data['id'] = user.id;
        _data['name'] = user.name;
        _data['email'] = user.email;
        _data['password'] = user.password;
        _data['discount'] = user.discount;
      }
    }
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
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
            height: 100,
            child: Text(
              'Dados do Usuário',
              style: Theme.of(context).textTheme.displaySmall,
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
                                    .requestFocus(_passwordFocus);
                              },
                              onSaved: (email) => _data['email'] = email ?? '',
                              validator: (e) {
                                final email = e ?? '';

                                if (email.trim().isEmpty) {
                                  return 'Email é obrigatório';
                                }

                                return null;
                              }),

                          // PASSWORD
                          TextFormField(
                            initialValue: _data['password']?.toString(),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  gapPadding: 20),
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: _passwordFocus,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_discountFocus);
                            },
                            onSaved: (password) =>
                                _data['password'] = password ?? '',
                            // validator: (e) {
                            //   final password = e ?? '';
                            //   return null;
                            // },
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
                                final discount =
                                    double.tryParse(eString) ?? 0.0;
                                return null;
                              }),
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
