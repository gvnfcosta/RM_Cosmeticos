import 'package:flutter/material.dart';
import '../common_widgets/auth_form.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  //Controladores de campos de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

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
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        child: Image.asset('assets/images/TelaInicial.png'),
                      ),
                    ),
                    Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2, top: 2),
                              child: Text(
                                'Catálogo\nde Produtos',
                                style: TextStyle(
                                    color: Colors.pink.shade200, fontSize: 42),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 0),
                              child: Text(
                                'Catálogo\nde Produtos',
                                style: TextStyle(
                                    color: Colors.pink.shade400, fontSize: 42),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w200,
                            color: Colors.pink),
                        child: AnimatedTextKit(
                          pause: Duration.zero,
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText('Maquiagem'),
                            FadeAnimatedText('Cremes'),
                            FadeAnimatedText('Shampoos'),
                            FadeAnimatedText('Condicionadores'),
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
              const AuthForm(),
            ],
          ),
        ),
      ),
    );
  }
}
