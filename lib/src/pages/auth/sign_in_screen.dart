import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/category_list.dart';
import '../../models/category_model.dart';
import '/src/pages/base/base_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '/src/config/custom_colors.dart';
import '../common_widgets/custom_text_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    final provider = Provider.of<CategoryList>(context);

    final List<Category> categories = provider.items.toList()
      ..sort(((a, b) => a.nome.compareTo(b.nome)));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SizedBox(
                            height: (deviceSize.height / 2),
                            child:
                                Image.asset('assets/images/TelaInicial.png'))),
                    SizedBox(
                      height: 35,
                      child: DefaultTextStyle(
                        style:
                            const TextStyle(fontSize: 25, color: Colors.pink),
                        child: AnimatedTextKit(
                          pause: Duration.zero,
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText('Maquiagem'),
                            FadeAnimatedText('Cremes'),
                            FadeAnimatedText('Shampoos'),
                            FadeAnimatedText('Condicionares'),
                            FadeAnimatedText('Infantil'),
                            FadeAnimatedText('Facial'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Formulário
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: BoxDecoration(
                    color: Colors.pinkAccent.withAlpha(70),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email
                    const CustomTextField(icon: Icons.email, label: 'Email'),

                    // Senha
                    const CustomTextField(
                        icon: Icons.lock, label: 'Senha', isSecret: true),

                    // Botão de Entrar
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.white10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (c) {
                                    return const BaseScreen();
                                  }),
                                );
                              },
                              child: const Text('Entrar',
                                  style: TextStyle(fontSize: 26)))),
                    ]),

                    // Esqueceu a Senha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Esqueceu a Senha?',
                          style: TextStyle(
                              color: CustomColors.customContrastColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
