import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../exceptions/auth_exception.dart';
import '../../models/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;
  bool _isObscure = false;

  @override
  void initState() {
    super.initState();
    _isObscure = true;
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreo um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
        // } else {
        //   // Registrar
        //   await auth.signup(
        //     _authData['email']!,
        //     _authData['password']!,
        //   );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
          color: Colors.pinkAccent.withAlpha(70),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      // height: _isLogin() ? 250 : 400,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.pink,
                ),
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.emailAddress,
              onSaved: (email) => _authData['email'] = email ?? '',
              validator: (email_) {
                final email = email_ ?? '';
                if (email.trim().isEmpty || !email.contains('@')) {
                  return 'Informe um e-mail válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.pink,
                ),
                suffixIcon: IconButton(
                    onPressed: (() {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }),
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.pink,
                    )),
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.emailAddress,
              obscureText: _isObscure,
              controller: _passwordController,
              onSaved: (password) => _authData['password'] = password ?? '',
              validator: (password_) {
                final password = password_ ?? '';
                if (password.isEmpty || password.length < 5) {
                  return 'Informe uma senha válida';
                }
                return null;
              },
            ),
            if (_isSignup())
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                validator: _isLogin()
                    ? null
                    : (password_) {
                        final password = password_ ?? '';
                        if (password != _passwordController.text) {
                          return 'Senhas informadas não conferem.';
                        }
                        return null;
                      },
              ),
            const SizedBox(height: 20),
            if (_isLoading)
              const LinearProgressIndicator()
            else
              SizedBox(
                height: 50,
                width: 180,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'ENTRAR',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
