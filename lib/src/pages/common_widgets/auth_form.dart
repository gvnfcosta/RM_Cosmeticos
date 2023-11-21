import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/data/store.dart';
import 'package:rm/src/pages/home/components/controllers/admin_controller.dart';
import '../../exceptions/auth_exception.dart';
import '../../models/auth.dart';

enum AuthMode { signup, login }

Auth auth = Auth();
bool _isWeb = AdminController().isWeb;

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _authData = {'email': '', 'password': ''};
  AuthMode _authMode = AuthMode.login;

  bool _isLoading = false;
  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;
  bool _isObscure = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late Box box;

  @override
  void initState() {
    super.initState();

    getdata();

    _isObscure = true;
    if (_isWeb) {
      _authData['email'] = 'loja@rm.com';
      _authData['senha'] = '123456';
      _iniciaWeb(_authData);
    }
  }

  Future<void> _iniciaWeb(authData) async {
    Auth auth = Provider.of(context, listen: false);
    await Future.delayed(const Duration(seconds: 3));
    await auth.login(authData['email'], authData['senha']);
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
      emailController.text = '';
      passwordController.text = '';
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
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

    if (!isValid) return;

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.login(_authData['email']!, _authData['password']!);
      } else {
        // Registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
      if (!_isWeb) login();
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return !_isWeb
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 0.5),
                    Color.fromRGBO(215, 117, 255, 0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: emailController,
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
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.pink,
                        ),
                        suffixIcon: IconButton(
                            onPressed: (() {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }),
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.pink,
                            )),
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: _isObscure,
                      controller: passwordController,
                      onSaved: (password) =>
                          _authData['password'] = password ?? '',
                      validator: (value) {
                        if (value!.length < 6) {
                          return "A senha não deve ter menos que 6 caracteres";
                        }
                        return null;
                      }),
                  const SizedBox(height: 5),
                  if (_isSignup())
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Colors.pink,
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: _isObscure,
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Senhas informadas não conferem.';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const LinearProgressIndicator()
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Text(
                              _authMode == AuthMode.login
                                  ? 'ENTRAR'
                                  : 'REGISTRAR',
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _switchAuthMode,
                          child: Text(
                            _isLogin() ? 'Criar uma conta' : 'Já tenho conta',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  void getdata() async {
    final loginData = await Store.getMap('loginData');

    if (loginData.isNotEmpty) {
      emailController.text = await loginData['email'];
      passwordController.text = await loginData['pass'];
      setState(() {});
    }
  }

  void login() async {
    final loginData = await Store.getMap('loginData');
    if (emailController.value.text != await loginData['email'] ||
        passwordController.value.text != await loginData['pass']) {
      Store.saveMap('loginData', {
        'email': emailController.value.text,
        'pass': passwordController.value.text
      });
    }
  }
}
