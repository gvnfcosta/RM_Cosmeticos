import 'package:flutter/material.dart';
import 'package:rm/src/pages/common_widgets/auth_auto.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:rm/src/pages/common_widgets/auth_form.dart';

bool isSite = false;

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
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 0.1),
                Color.fromRGBO(215, 117, 255, 0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        //height: 300,
                        child: Image.asset('assets/images/TelaInicial.png'),
                      ),
                    ),
                    Column(
                      children: [
                        Stack(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 2, top: 1),
                              child: Text(
                                'Catálogos\nde Produtos',
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 50),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 0),
                              child: Text(
                                'Catálogos\nde Produtos',
                                style: TextStyle(
                                    color: Colors.pink.shade600, fontSize: 50),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w200,
                            color: Colors.pink.shade700),
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
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              //Formulário
              !isSite ? const AuthForm() : const AuthAuto(),
            ],
          ),
        ),
      ),
    );
  }
}
