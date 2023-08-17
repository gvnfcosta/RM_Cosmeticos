import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../exceptions/auth_exception.dart';
import '../../models/auth.dart';

enum AuthMode { signup, login }

Auth auth = Auth();
bool isWeb = false;

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;

  final Map<String, String> _authData = {'email': '', 'password': ''};

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;
  bool _isObscure = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late Box box;

  @override
  void initState() {
    super.initState();

    createOpenBox();

    _isObscure = true;
    if (isWeb) {
      _authData['email'] = 'loja@rm.com';
      _authData['senha'] = '123456';
      _iniciaWeb(_authData);
    } else {}
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
            _authData['email']!, _authData['password'] ?? '123456');
      } else {
        // Registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
      login();
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return !isWeb
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.pink.withAlpha(30),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
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
                  const SizedBox(height: 5),
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
                    validator: (password_) {
                      final password = password_ ?? '';
                      if (password.isEmpty || password.length < 5) {
                        return 'Informe uma senha válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  if (_isSignup())
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.pink,
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      validator: (password_) {
                        final password = password_ ?? '';
                        if (password != passwordController.text) {
                          return 'Senhas informadas não conferem.';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 5),
                  if (_isLoading)
                    const LinearProgressIndicator()
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 180,
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
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _switchAuthMode,
                          child: Text(
                            _isLogin() ? 'Não tenho conta' : 'Já tenho conta',
                            style: const TextStyle(fontSize: 12),
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

  void createOpenBox() async {
    box = await Hive.openBox('user_data');
    getdata();
  }

  void getdata() async {
    if (box.get('email') != null) {
      emailController.text = box.get('email');
      setState(() {});
    }
    if (box.get('pass') != null) {
      passwordController.text = box.get('pass');
      setState(() {});
    }
  }

  void login() {
    if (emailController.value.text != box.get('email') ||
        passwordController.value.text != box.get('password')) {
      box.put('email', emailController.value.text);
      box.put('pass', passwordController.value.text);
    }
  }
}
