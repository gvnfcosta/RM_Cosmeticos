import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:rm/src/pages/common_widgets/auth_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  //Controladores de campos de texto

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/TelaInicial.png',
                  fit: BoxFit.contain,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 2, top: 2),
                      child: Text(
                        'Catálogos de Produtos',
                        style: TextStyle(
                            color: Colors.black26,
                            fontSize: 30,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      'Catálogos de Produtos',
                      style: TextStyle(
                          color: Colors.pink.shade600,
                          fontSize: 30,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    child: DefaultTextStyle(
                      style: TextStyle(
                          fontSize: 30,
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
                ],
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
