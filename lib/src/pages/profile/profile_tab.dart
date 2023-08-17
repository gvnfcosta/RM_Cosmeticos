import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/components/app_drawer.dart';
import '/src/config/app_data.dart' as appData;
import '../../models/auth.dart';
import '../../models/user_list.dart';
import '../../utils/app_routes.dart';
import '/src/pages/common_widgets/custom_text_field.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

bool _isLoading = true;
bool _isObscure = false;

String? _oldPassword = '';
String? _newPassword = '';
String? _confirmPassword = '';

class _ProfileTabState extends State<ProfileTab> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<UserList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context, listen: false);

    UserList userProvider = Provider.of<UserList>(context);

    String? userName = userProvider.userName;
    bool isAdmin = userProvider.isAdmin;
    int? userLevel = userProvider.userLevel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.authOrHome,
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(fontSize: 28, color: Colors.red),
                  child: AnimatedTextKit(
                    pause: Duration.zero,
                    repeatForever: true,
                    animatedTexts: [
                      FadeAnimatedText('AGUARDE'),
                      FadeAnimatedText('AGUARDE'),
                    ],
                  ),
                ),
                const Center(
                  child: SizedBox(
                    height: 5,
                    width: 200,
                    child: LinearProgressIndicator(),
                  ),
                ),
              ],
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              children: [
                //Email
                CustomTextField(
                    readOnly: true,
                    initialValue: userName,
                    icon: Icons.nature_people,
                    label: 'Usuário'),
                // Nome
                CustomTextField(
                  readOnly: true,
                  initialValue: appData.Constants.levels[userLevel],
                  icon: Icons.person,
                  label: 'Nível',
                ),
                // Nome
                CustomTextField(
                  readOnly: true,
                  initialValue: auth.email,
                  icon: Icons.person,
                  label: 'Email',
                ),
                //Botão para atualizar a senha
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      updatePassword();
                    },
                    child: const Text('Atualizar Senha'),
                  ),
                ),
              ],
            ),
      drawer: isAdmin ? const AppDrawer() : null,
    );
  }

  updatePassword() {
    Auth auth = Provider.of(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        // Título
                        child: Text('Atualização de Senha',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      // Senha atual
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Senha Atual',
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          prefixIcon: const Icon(
                            Icons.password,
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
                        controller: oldPasswordController,
                        onSaved: (password) => _oldPassword = password ?? '',
                        validator: (password_) {
                          final password = password_ ?? '';
                          if (password.isEmpty || password.length < 5) {
                            return 'Informe uma senha válida';
                          }
                          return null;
                        },
                      ),
                      // Nova senha
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nova Senha',
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          prefixIcon: const Icon(
                            Icons.password,
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
                        controller: newPasswordController,
                        onSaved: (password) => _newPassword = password ?? '',
                        validator: (value) {
                          if (value!.length < 6) {
                            return "A senha não deve ter menos que 6 caracteres";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      //Confirmação nova senha
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
                          onSaved: (password) =>
                              _confirmPassword = password ?? '',
                          validator: (value) {
                            if (value != newPasswordController.text) {
                              return 'Senhas informadas não conferem.';
                            }
                            return null;
                          }),
                      const SizedBox(height: 10),
                      // Botão de confirmação
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed:
                              // authController.isLoading.value
                              //       ? null
                              //       :
                              () {
                            if (_formKey.currentState!.validate()) {
                              // authController.changePassword(
                              //   currentPassword:
                              //       oldPasswordController.text,
                              //   newPassword:
                              //       newPasswordController.text,
                              // );
                            }
                          },
                          child: const Text('ATUALIZAR'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
