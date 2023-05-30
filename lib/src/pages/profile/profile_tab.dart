import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/components/app_drawer.dart';
import '../../models/auth.dart';
import '../../models/user_list.dart';
import '../../models/user_model.dart';
import '../../utils/app_routes.dart';
import '/src/pages/common_widgets/custom_text_field.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

bool _isLoading = true;
bool isAdmin = false;

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();

    Provider.of<UserList>(context, listen: false).loadData().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    List<UserModel> user = Provider.of<UserList>(context).usuario;
    if (user.isNotEmpty) {
      isAdmin = user.first.level == 5;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logout();
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
                    initialValue: user.first.name,
                    icon: Icons.nature_people,
                    label: 'Usuário'),

                // Nome
                CustomTextField(
                  readOnly: true,
                  initialValue: user.first.level.toString(),
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

  Future<bool?> updatePassword() {
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
                    const CustomTextField(
                      isSecret: true,
                      icon: Icons.lock,
                      label: 'Senha atual',
                    ),

                    // Nova senha
                    const CustomTextField(
                      isSecret: true,
                      icon: Icons.lock_outline,
                      label: 'Nova senha',
                    ),

                    //Confirmação nova senha
                    const CustomTextField(
                      isSecret: true,
                      icon: Icons.lock_outline,
                      label: 'Confirmar nova senha',
                    ),

                    // Botão de confirmação
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('ATUALIZAR'),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ;
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
